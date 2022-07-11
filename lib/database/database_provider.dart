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

  static Future<List<Map<String, dynamic>>> selectAll(
      {required Table from}) async {
    final db = _db;
    if (db != null) {
      switch (from) {
        case Table.tours:
          return await _selectAllFromTours(db);
        case Table.clients:
          return await _selectAllFromClients(db);
        case Table.tourAgents:
          return await _selectAllFromTourAgents(db);
      }
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> selectByTourId(
      {required Table from, required int id}) async {
    final db = _db;
    if (db != null) {
      switch (from) {
        case Table.clients:
          return await _selectByTourIdFromClients(db, id);
        case Table.tourAgents:
          return await _selectByTourIdFromTourAgents(db, id);
        case Table.tours:
          return [];
      }
    }
    return [];
  }

  static Future<Map<String, dynamic>> addItem({
    required Map<String, dynamic> data,
    required Table to,
  }) async {
    final db = _db;
    if (db != null) {
      switch (to) {
        case Table.clients:
          return await _addItemToClients(data: data, db: db);
        case Table.tourAgents:
          return await _addItemToTourAgents(data: data, db: db);
        case Table.tours:
          return await _addItemToTours(data: data, db: db);
      }
    } else {
      return {};
    }
  }

  static Future<Map<String, dynamic>> updateItem({
    required Map<String, dynamic> data,
    required int id,
    required Table of,
  }) async {
    final db = _db;
    if (db != null) {
      switch (of) {
        case Table.clients:
          return await _updateItemOfClients(data: data, id: id, db: db);
        case Table.tourAgents:
          return await _updateItemOfTourAgents(data: data, id: id, db: db);
        case Table.tours:
          return await _updateItemOfTours(data: data, id: id, db: db);
      }
    } else {
      return {};
    }
  }

  static Future<Map<String, dynamic>> deleteItemBy({
    required int id,
    required Table from,
  }) async {
    final db = _db;
    if (db != null) {
      switch (from) {
        case Table.clients:
          return await _deleteItemFromClients(id: id, db: db);
        case Table.tourAgents:
          return await _deleteItemFromTourAgents(id: id, db: db);
        case Table.tours:
          return {};
      }
    } else {
      return {};
    }
  }

  static Future<Map<String, dynamic>> _updateItemOfClients({
    required Map<String, dynamic> data,
    required int id,
    required Database db,
  }) async {
    final client = Client.fromMap(map: data);
    final sql = '''
          UPDATE $_clientsTable SET
    ${Client.tourIdKey}=@${Client.tourIdKey},
    ${Client.nameKey}=@${Client.nameKey},
    ${Client.hasPaidKey}=@${Client.hasPaidKey},
    ${Client.quantityOfTicketsKey}=@${Client.quantityOfTicketsKey}
    WHERE ${Client.clientIdKey}=$id
    RETURNING ${Client.clientIdKey}
    ''';
    final params = <String, dynamic>{
      Client.tourIdKey: client.tourId,
      Client.nameKey: client.name,
      Client.hasPaidKey: client.hasPaid,
      Client.quantityOfTicketsKey: client.quantityOfTickets,
    };
    final result = await db.query(sql, values: params);

    return {'updated_element': result[0][_clientsTable]};
  }

  static Future<Map<String, dynamic>> _updateItemOfTours({
    required Map<String, dynamic> data,
    required int id,
    required Database db,
  }) async {
    final tour = Tour.fromMap(map: data);
    final sql = '''
          UPDATE $_toursTable SET
        ${Tour.nameKey} = @${Tour.nameKey},
        ${Tour.startDateKey}=@${Tour.startDateKey},
        ${Tour.endDateKey}=@${Tour.endDateKey},
        ${Tour.destinationKey}=@${Tour.destinationKey},
        ${Tour.wayOfTravelingKey}=@${Tour.wayOfTravelingKey}
        WHERE ${Tour.tourIdKey}=$id
         RETURNING ${Tour.tourIdKey}
        ''';
    final params = <String, dynamic>{
      Tour.nameKey: tour.name,
      Tour.startDateKey: tour.startDate,
      Tour.endDateKey: tour.endDate,
      Tour.destinationKey: tour.destination,
      Tour.wayOfTravelingKey: tour.wayOfTraveling,
    };
    final result = await db.query(sql, values: params);

    return {'updated_element': result[0][_toursTable]};
  }

  static Future<Map<String, dynamic>> _updateItemOfTourAgents({
    required Map<String, dynamic> data,
    required int id,
    required Database db,
  }) async {
    final tourAgent = TourAgent.fromMap(map: data);
    final sql = '''
        UPDATE $_tourAgentsTable SET
        ${TourAgent.tourIdKey}=@${TourAgent.tourIdKey},
        ${TourAgent.nameKey}=@${TourAgent.nameKey},
        ${TourAgent.positionKey}=@${TourAgent.positionKey},
        ${TourAgent.experienceKey}=@${TourAgent.experienceKey}
        WHERE ${TourAgent.agentIdKey}=$id
        RETURNING ${TourAgent.agentIdKey}
        ''';
    final params = <String, dynamic>{
      TourAgent.tourIdKey: tourAgent.tourId,
      TourAgent.nameKey: tourAgent.name,
      TourAgent.positionKey: tourAgent.position,
      TourAgent.experienceKey: tourAgent.experience,
    };
    final result = await db.query(sql, values: params);

    return {'updated_element': result[0][_tourAgentsTable]};
  }

  static Future<Map<String, dynamic>> _deleteItemFromClients({
    required int id,
    required Database db,
  }) async {
    final sql = '''
          DELETE FROM $_clientsTable WHERE 
    ${Client.clientIdKey}='$id'
    RETURNING ${Client.clientIdKey}
            ''';
    final result = await db.query(sql);
    return {'deleted_element': result[0][_clientsTable]};
  }

  static Future<Map<String, dynamic>> _deleteItemFromTourAgents({
    required int id,
    required Database db,
  }) async {
    final sql = '''
          DELETE FROM $_tourAgentsTable WHERE 
    ${TourAgent.agentIdKey}='$id'
    RETURNING ${TourAgent.agentIdKey}
            ''';
    final result = await db.query(sql);
    return {'deleted_element': result[0][_tourAgentsTable]};
  }

  static Future<Map<String, dynamic>> _addItemToClients({
    required Map<String, dynamic> data,
    required Database db,
  }) async {
    final client = Client.fromMap(map: data);
    const sql = '''
          insert into $_clientsTable (${Client.tourIdKey},${Client.nameKey},
        ${Client.hasPaidKey},${Client.quantityOfTicketsKey})
        VALUES (@${Client.tourIdKey},@${Client.nameKey},
        @${Client.hasPaidKey},@${Client.quantityOfTicketsKey}) RETURNING ${Client.clientIdKey}
        ''';
    final params = <String, dynamic>{
      Client.tourIdKey: client.tourId,
      Client.nameKey: client.name,
      Client.hasPaidKey: client.hasPaid,
      Client.quantityOfTicketsKey: client.quantityOfTickets,
    };
    final result = await db.query(sql, values: params);

    return {'inserted_element': result[0][_clientsTable]};
  }

  static Future<Map<String, dynamic>> _addItemToTourAgents({
    required Map<String, dynamic> data,
    required Database db,
  }) async {
    final tourAgent = TourAgent.fromMap(map: data);
    const sql = '''
          insert into $_tourAgentsTable (${TourAgent.tourIdKey},${TourAgent.nameKey},
        ${TourAgent.positionKey},${TourAgent.experienceKey})
        VALUES (@${TourAgent.tourIdKey},@${TourAgent.nameKey},
        @${TourAgent.positionKey},@${TourAgent.experienceKey}) RETURNING ${TourAgent.agentIdKey}
        ''';
    final params = <String, dynamic>{
      TourAgent.tourIdKey: tourAgent.tourId,
      TourAgent.nameKey: tourAgent.name,
      TourAgent.positionKey: tourAgent.position,
      TourAgent.experienceKey: tourAgent.experience,
    };
    final result = await db.query(sql, values: params);

    return {'inserted_element': result[0][_tourAgentsTable]};
  }

  static Future<Map<String, dynamic>> _addItemToTours({
    required Map<String, dynamic> data,
    required Database db,
  }) async {
    final tour = Tour.fromMap(map: data);
    const sql = '''
          insert into $_toursTable (${Tour.nameKey},
        ${Tour.startDateKey},${Tour.endDateKey},${Tour.destinationKey},${Tour.wayOfTravelingKey})
        VALUES (@${Tour.nameKey},
        @${Tour.startDateKey},@${Tour.endDateKey},@${Tour.destinationKey},
        @${Tour.wayOfTravelingKey}) RETURNING ${Tour.tourIdKey}
        ''';
    final params = <String, dynamic>{
      Tour.nameKey: tour.name,
      Tour.startDateKey: tour.startDate,
      Tour.endDateKey: tour.endDate,
      Tour.destinationKey: tour.destination,
      Tour.wayOfTravelingKey: tour.wayOfTraveling,
    };
    final result = await db.query(sql, values: params);

    return {'inserted_element': result[0][_toursTable]};
  }

  static Future<List<Map<String, dynamic>>> _selectAllFromTourAgents(
      Database db) async {
    final items = <Map<String, dynamic>>[];
    final result = await db.query('''
          SELECT * FROM $_tourAgentsTable
    ORDER BY ${TourAgent.agentIdKey} ASC 
    ''');
    for (final row in result) {
      items.add(row[_tourAgentsTable]);
    }
    return items;
  }

  static Future<List<Map<String, dynamic>>> _selectAllFromClients(
      Database db) async {
    final items = <Map<String, dynamic>>[];
    final result = await db.query('''
          SELECT * FROM $_clientsTable
    ORDER BY ${Client.clientIdKey} ASC 
    ''');
    for (final row in result) {
      items.add(row[_clientsTable]);
    }
    return items;
  }

  static Future<List<Map<String, dynamic>>> _selectAllFromTours(
      Database db) async {
    final items = <Map<String, dynamic>>[];
    final result = await db.query('''
          SELECT * FROM $_toursTable
    ORDER BY ${Tour.tourIdKey} ASC 
    ''');
    final formatter = DateFormat('yyyy-MM-dd');
    for (final row in result) {
      final item = row[_toursTable];
      if (item[Tour.startDateKey] is DateTime &&
          item[Tour.endDateKey] is DateTime) {
        item[Tour.startDateKey] = formatter.format(item[Tour.startDateKey]);
        item[Tour.endDateKey] = formatter.format(item[Tour.endDateKey]);
      }
      items.add(row[_toursTable]);
    }
    return items;
  }

  static Future<List<Map<String, dynamic>>> _selectByTourIdFromTourAgents(
      Database db, int id) async {
    final items = <Map<String, dynamic>>[];
    final result = await db.query('''
          SELECT * FROM $_tourAgentsTable
          WHERE ${TourAgent.tourIdKey}=$id
          ORDER BY ${TourAgent.agentIdKey} ASC 
    ''');
    for (final row in result) {
      items.add(row[_tourAgentsTable]);
    }
    return items;
  }

  static Future<List<Map<String, dynamic>>> _selectByTourIdFromClients(
      Database db, int id) async {
    final items = <Map<String, dynamic>>[];
    final result = await db.query('''
          SELECT * FROM $_clientsTable
          WHERE ${Client.tourIdKey}=$id
    ORDER BY ${Client.clientIdKey} ASC 
    ''');
    for (final row in result) {
      items.add(row[_clientsTable]);
    }
    return items;
  }
}
