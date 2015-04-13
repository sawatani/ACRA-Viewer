library credential;

import 'dart:async';
import 'dart:js';

import 'package:angular/angular.dart';

import 'package:acra_viewer/util/cordova.dart';
import 'package:acra_viewer/util/after_done.dart';

@Injectable()
class Credential {
  static const awsRegion = "us-east-1";
  static const awsApiKey = "AIzaSyC-RwPWTsW9dd4aGZPMe3f7K67Wh0zHLCI";
  static const cognitoId = "us-east-1:fcf0d3cc-c16f-4221-be60-5838f9f5421e";
  static const googleClientId = "567792211222-rh242nv550rlc7hdi249c3uvgk6olfqt.apps.googleusercontent.com";
  static const scopes = const ["https://www.googleapis.com/auth/plus.login", "https://www.googleapis.com/auth/admin.directory.group.member.readonly"];
  static const googleGroupEmail = "campany@fathens.org";

  static final AfterDone<String> _connected = new AfterDone<String>("Credential connected");
  static void onConnected(void proc(String)) => _connected.listen(proc);
  static bool get isConnected => _connected.isDone;

  static bool _initialize() {
    print("Initializing credentials ...");
    context['AWS']['config']['region'] = awsRegion;
    context['AWS']['config']['credentials'] = new JsObject(context['AWS']['CognitoIdentityCredentials'], [new JsObject.jsify({'IdentityPoolId': cognitoId})]);
    context['gapi']['client'].callMethod('setApiKey', [awsApiKey]);
    return true;
  }
  static final setup = _initialize();

  static String stringify(JsObject obj) => context['JSON'].callMethod('stringify', [obj]);

  RootScope rootScope;

  Credential(this.rootScope) {
    // Need to eval 'setup' to exec '_initialize()'
    print("Credential is instantiated: ${setup}");
  }

  Future<JsObject> _request(String path) {
    final result = new Completer();
    context['gapi']['client'].callMethod('request', [new JsObject.jsify({'path': path})]).callMethod('then', [
      (res) {
        result.complete(res['result']);
      },
      (error) {
        result.completeError(error.result.error.message);
      }
    ]);
    return result.future;
  }

  Future<String> _getUserId() async {
    final result = await _request('/plus/v1/people/me');
    print("me: ${stringify(result)}");
    return result['id'];
  }

  Future<bool> _isMember(String userId) async {
    final result = await _request('/admin/directory/v1/groups/${Uri.encodeFull(googleGroupEmail)}/members');
    final JsArray members = result['members'];
    print("Group members: ${stringify(members)}");
    final index = members.map((m) {
      return m['id'];
    }).toList().indexOf(userId);
    return 0 <= index;
  }

  void _setGoogleToken(String token) {
    print("Google Signin Token: ${token}");
    final creds = context['AWS']['config']['credentials'];
    creds['params']['Logins'] = new JsObject.jsify({'accounts.google.com': token});
    creds['expired'] = true;
  }

  Future<String> _auth(bool immediate) {
    final result = new Completer();
    context['gapi']['auth'].callMethod('authorize', [
      new JsObject.jsify({'client_id': googleClientId, 'scope': scopes.join(' '), 'response_type': 'token id_token', 'immediate': immediate}),
      (res) {
        print("Google Auth Result: ${stringify(res)}");
        if (res['error'] != null) {
          result.completeError("Google Signin Error: ${res['error']}");
        } else {
          result.complete(res['id_token']);
        }
      },
      (error) {
        result.completeError(error.result.error.message);
      }
    ]);
    return result.future;
  }

  Future<bool> signinGoogle(bool immediate) async {
    Future<bool> _onBrowser() async {
      final token = await _auth(immediate);
      final userId = await _getUserId();
      final member = await _isMember(userId);
      if (member) _setGoogleToken(token);
      return member;
    }
    Future<bool> _onCordova() {
      final result = new Completer();
      new Timer(new Duration(seconds: 3), () {
        result.complete(true);
      });
      return result.future;
    }
    final ok = Cordova.isCordova ? await _onCordova() : await _onBrowser();
    if (ok) {
      _connected.done("");
    }
    return ok;
  }
}
