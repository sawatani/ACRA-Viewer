library credential;

import 'dart:async';
import 'dart:js';

import 'package:angular/angular.dart';

@Injectable()
class Credential {
  static final List<String> scopes = ["https://www.googleapis.com/auth/plus.login", "https://www.googleapis.com/auth/admin.directory.group.member.readonly"];
  static final String clientId = "567792211222-rh242nv550rlc7hdi249c3uvgk6olfqt.apps.googleusercontent.com";
  static _initialize() {
    context['AWS']['config']['region'] = "us-east-1";
    context['AWS']['config']['credentials'] = new JsObject(context['AWS']['CognitoIdentityCredentials'], [new JsObject.jsify({
        'IdentityPoolId': 'us-east-1:fcf0d3cc-c16f-4221-be60-5838f9f5421e'
      })]);
    context['gapi']['client'].callMethod('setApiKey', ['AIzaSyC-RwPWTsW9dd4aGZPMe3f7K67Wh0zHLCI']);
    return true;
  }
  static final bool setup = _initialize();

  Future<JsObject> _request(String path) {
    final result = new Completer();
    context['gapi']['client'].callMethod('request', new JsObject.jsify({
      'path': path
    })).callMethod('then', [(res) {
        result.complete(res['result']);
      }, (error) {
        result.completeError(error.result.error.message);
      }]);
    return result;
  }

  Future<String> _getUserId() {
    return _request('/plus/v1/people/me').then((result) {
      print("me: ${result}");
      return result['id'].toString();
    }).catchError((error) {
      print("Failed to get user id: ${error}");
    });
  }

  Future<bool> _isMember(String userId) {
    return _request('/admin/directory/v1/groups/campany%40fathens.org/members').then((result) {
      final JsArray members = result['members'];
      print("Group members: ${members}");
      final index = members.map((m) {
        return m['id'].toString();
      }).toList().indexOf(userId);
      return 0 <= index;
    }).catchError((error) {
      print("Failed to get group members: ${error}");
    });
  }

  void _setGoogleToken(String token) {
    print("Google Signin Token: ${token}");
    final creds = context['AWS']['config']['credentials'];
    creds['params']['Logins'] = new JsObject.jsify({
      'accounts.google.com': token
    });
    creds['expired'] = true;
  }

  Future<bool> signinGoogle() {
    final result = new Completer();
    context['gapi']['auth'].callMethod('authorize', [new JsObject.jsify({
        'client_id': clientId,
        'scope': scopes.join(' '),
        'immediate': true
      }), (res) {
        if (res['error']) {
          result.completeError("Google Signin Error: ${res['error']}");
        } else {
          _getUserId().then(_isMember).then((bool ok) {
            if (ok) {
              _setGoogleToken(res['id_token']);
            } else {
              print("This user is not permitted.");
            }
            result.complete(ok);
          }).catchError((error) {
            result.completeError("Error: ${error}");
          });
        }
      }]);
    return result;
  }
}
