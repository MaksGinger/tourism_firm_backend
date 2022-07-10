import 'dart:async';

import 'package:intl/intl.dart' show DateFormat;
import 'package:tourism_firm_backend/database/database.dart';
import 'package:tourism_firm_backend/database/table.dart';
import 'package:tourism_firm_backend/models/client.dart';
import 'package:tourism_firm_backend/models/tour.dart';
import 'package:tourism_firm_backend/models/tour_agent.dart';

abstract class DatabaseProvider {
  static const String _toursTable = 'tours';
  static const String _clientsTable = 'clients';
  static const String _tourAgentsTable = 'tour_agents';

  static Database? _db;

  static Future<void> init({
    required String host,
    required String user,
    required String pass,
    required String name,
    required int port,
  }) async {
    _db ??= await Database.connect(
      name: name,
      host: host,
      user: user,
      pass: pass,
      port: port,
    );
  }

  static Future<List<dynamic>> selectAll({required Table from}) async {
    final items = <Map<String, dynamic>>[];
    final db = _db;
    if (db != null) {
      switch (from) {
        case Table.tours:
          final result = await db.mappedQuery('''
          SELECT * FROM $_toursTable
          ORDER BY ${Tour.tourIdKey} ASC 
          ''');
          final formatter = DateFormat('yyyy-MM-dd');
          for (final row in result) {
            final item = row[_toursTable];
            if (item[Tour.startDateKey] is DateTime &&
                item[Tour.endDateKey] is DateTime) {
              item[Tour.startDateKey] =
                  formatter.format(item[Tour.startDateKey]);
              item[Tour.endDateKey] = formatter.format(item[Tour.endDateKey]);
            }
            items.add(row[_toursTable]);
          }
          break;
        case Table.clients:
          final result = await db.mappedQuery('''
          SELECT * FROM $_clientsTable
          ORDER BY ${Client.clientIdKey} ASC 
          ''');
          for (final row in result) {
            items.add(row[_clientsTable]);
          }
          break;
        case Table.tourAgents:
          final result = await db.mappedQuery('''
          SELECT * FROM $_tourAgentsTable
          ORDER BY ${TourAgent.agentIdKey} ASC 
          ''');
          for (final row in result) {
            items.add(row[_tourAgentsTable]);
          }
          break;
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
