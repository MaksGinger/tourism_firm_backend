import 'package:postgres/postgres.dart';

class Database {
  late final PostgreSQLConnection _connection;

  static Future<Database> connect({
    required String host,
    required String user,
    required String pass,
    required String name,
    required int port,
  }) async {
    final db = Database();
    db._connection = PostgreSQLConnection(
      host,
      port,
      name,
      username: user,
      password: pass,
    );
    await db._connection.open();
    return db;
  }

  Future<List<dynamic>> query(
    String sql, {
    Map<String, dynamic>? values,
  }) async {
    try {
      return await _connection.mappedResultsQuery(
        sql,
        substitutionValues: values,
      );
    } catch (_) {
      return Future.value([]);
    }
  }
}
