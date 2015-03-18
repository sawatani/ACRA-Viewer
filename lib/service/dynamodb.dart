library dynamodb;

import 'dart:async';
import 'dart:convert';
import 'dart:js';

import 'package:angular/angular.dart';

@Injectable()
class DynamoDB {
  Future<List<App>> get allApps => loadAllApps();

  Future<List<App>> loadAllApps() => new _DB().allList('APPLICATIONS', (item) {
    final id = item['ID']['S'];
    final tableName = item['CONFIG']['M']['tableName']['S'];
    return new App(id, tableName);
  });

  Future<List<Report>> loadAllReports(String tableName) => new _DB().allList(tableName, (item) {
    final id = item['ID']['S'];
    final created = item['CREATED_AT']['S'];
    final text = item['REPORT']['S'];
    return new Report(id, DateTime.parse(created), text);
  });
}

class _DB {
  final db = new JsObject(context['AWS']['DynamoDB']);

  Future<List> allList(String tableName, f(JsObject item)) => scan({
    'TableName': "ACRA.${tableName}"
  }, f);

  Future<List> scan(Map<String, String> params, f(JsObject item)) {
    final result = new Completer();
    db.callMethod('scan', [new JsObject.jsify(params), (error, JsObject data) {
        if (error != null) {
          result.completeError(error);
        } else {
          result.complete(data['Items'].map(f).toList());
        }
      }]);
    print("Returning temporaly future...");
    return result.future;
  }
}

class App {
  final String id;
  final String tableName;

  App(this.id, this.tableName) {
    print("Created app: ${id} with ${tableName}");
  }
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
