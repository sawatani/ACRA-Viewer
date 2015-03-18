library dynamodb;

import 'dart:async';
import 'dart:convert';
import 'dart:js';
import 'dart:html';

import 'package:angular/angular.dart';

@Injectable()
class DynamoDB {
  final _apps = new Delegate<App>("APPLICATIONS", (JsObject item) {
    final id = item['ID']['S'];
    final tableName = item['CONFIG']['M']['tableName']['S'];
    return new App(id, tableName);
  });

  List<App> _cachedApps = null;
  List<App> get allApps => _cachedApps;

  DynamoDB() {
    window.addEventListener("AWS.RENEW_CREDENTIAL", (Event event) {
      refreshApps();
    });
  }

  void refreshApps() {
    print("Start to refresh applications list");
    _apps.allList().then((List<App> list) {
      _cachedApps = list;
    }).catchError((error) {
      _cachedApps = null;
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
  var _table;

  App(this.id, this.tableName) {
    print("Created app: ${id} with ${tableName}");
    _table = new Delegate<Report>(tableName, (item) {
      final id = item['ID']['S'];
      final created = item['CREATED_AT']['S'];
      final text = item['REPORT']['S'];
      return new Report(id, DateTime.parse(created), text);
    });
  }

  Future<List<Report>> allReports() => _table.allList();
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

  String get stackTrace => _map['STACKTRACE'].toString();
}
