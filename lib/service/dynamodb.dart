library dynamodb;

import 'dart:async';
import 'dart:convert';
import 'dart:js';

import 'package:acra_viewer/service/credential.dart' as Cred;
import 'package:angular/angular.dart';

@Injectable()
class DynamoDB {
  final _apps = new Delegate<App>("APPLICATIONS", (JsObject item) {
    final id = item['ID']['S'];
    final tableName = item['CONFIG']['M']['tableName']['S'];
    return new App(id, tableName);
  });

  final Scope scope;
  List<App> _cachedApps = null;
  List<App> get allApps => _cachedApps;

  DynamoDB(this.scope) {
    scope.rootScope.on(Cred.Credential.EVENT_CONNECTED).listen((event) {
      //refreshApps();
      _cachedApps = [new App('TritonNote', 'TritonNote')];
    });
  }

  App getApp(String id) {
    if (allApps == null) return null;
    return allApps.firstWhere((a) {
      return a.id == id;
    });
  }

  void refreshApps() {
    print("Start to refresh applications list");
    _apps.allList().then((List<App> list) {
      scope.apply(() {
        _cachedApps = list;
      });
    }).catchError((error) {
      scope.apply(() {
        _cachedApps = null;
      });
      print("Failed to get applications list: ${error}");
    });
  }
}

class Delegate<T> {
  static final db = new JsObject(context['AWS']['DynamoDB']);

  final String tableName;
  var _converter;

  Delegate(this.tableName, T f(JsObject item)) {
    _converter = f;
  }

  Future<List<T>> allList() => scan({});

  Future<List<T>> scan(Map<String, String> params) {
    params['TableName'] = "ACRA.${tableName}";
    final result = new Completer();
    db.callMethod('scan', [new JsObject.jsify(params), (error, JsObject data) {
        if (error != null) {
          result.completeError(error);
        } else {
          result.complete(data['Items'].map(_converter).toList());
        }
      }]);
    print("Returning temporaly future...");
    return result.future;
  }
}

class App {
  final String id;
  final String tableName;
  Delegate<Report> _table;

  List<Report> _cachedReports = null;
  List<Report> get allReports => _cachedReports;

  App(this.id, this.tableName) {
    print("Created app: ${id} with ${tableName}");
    _table = new Delegate<Report>(tableName, (item) {
      final id = item['ID']['S'];
      final created = item['CREATED_AT']['S'];
      final text = item['REPORT']['S'];
      return new Report(id, DateTime.parse(created), text);
    });
    //refreshReports();
  }

  Report getReport(String id) {
    if (allReports == null) return null;
    return allReports.firstWhere((a) {
      return a.id == id;
    });
  }

  Future<List<Report>> refreshReports() => _table.allList().then((list) {
    list.sort((a, b) {
      return b.timestamp.compareTo(a.timestamp);
    });
    return list;
  }).then((list) {
    _cachedReports = list;
  });
}

class Report {
  final String id;
  final String text;
  final DateTime timestamp;
  var _map;

  Report(this.id, this.timestamp, this.text) {
    print("Created report: ${id}: ${timestamp}");
    _map = JSON.decode(text);
  }

  String get androidVersion => _map['ANDROID_VERSION'].toString();
  String get phoneModel => _map['PHONE_MODEL'].toString();
  String get versionName => _map['APP_VERSION_NAME'].toString();
  String get stackTrace => _map['STACK_TRACE'].toString();
  String get logcat => _map['LOGCAT'].toString();
}
