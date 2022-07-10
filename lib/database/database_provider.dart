import 'dart:async';

import 'package:tourism_firm_backend/database/database.dart';
import 'package:tourism_firm_backend/database/table.dart';

abstract class DatabaseProvider {
  static Database? _db;

  static Future<void> init({
    required String host,
    required String user,
    required String pass,
    required String name,
    required int port,
  }) async =>
      _db = await Database.connect(
        name: name,
        host: host,
        user: user,
        pass: pass,
        port: port,
      );

  static Future<List<dynamic>> selectAll({required Table from}) async {
    final items = <Map<String, dynamic>>[];
    final db = _db;
    if (db != null) {
      final result = await db.query('select id, name from items');
      for (final row in result) {
        items.add(row['items']);
      }
    }
    return items;
  }

  // static Future<Map<String, dynamic>> addItem(dynamic data) async {
  //   final db = _db;
  //   if (db != null) {
  //     final item = Item.fromDynamicMap(data);
  //     const sql =
  //         'insert into items (name, description) VALUES (@name, @description) RETURNING id';
  //     final params = <String, dynamic>{
  //       'name': item.name,
  //       'description': item.description
  //     };
  //     dynamic result = await db.query(sql, values: params);

  //     return {'id': result[0]['items']['id']};
  //   } else {
  //     return {};
  //   }
  // }
}
