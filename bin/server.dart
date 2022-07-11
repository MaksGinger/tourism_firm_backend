import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:tourism_firm_backend/database/database_provider.dart';
import 'package:tourism_firm_backend/database/table.dart';

abstract class Routes {
  static const String root = '/';
  static const String tours = '/tours';
  static const String clients = '/clients';
  static const String tourAgents = '/tour_agents';
}

class Server {
  static dynamic _decode(Request request) async =>
      jsonDecode(await request.readAsString());

  static String _encode(Object? data) => jsonEncode(data);

  final _router = Router()
    ..get(Routes.root, _rootHandler)
    ..get(Routes.tours, _toursGetHandler)
    ..get(Routes.clients, _clientsGetHandler)
    ..get(Routes.tourAgents, _tourAgentsGetHandler)
    ..post(Routes.clients, _clientsPostHadler)
    ..post(Routes.tourAgents, _tourAgentsPostHadler)
    ..post(Routes.tours, _toursPostHadler);

  static Response _rootHandler(Request request) {
    return Response.ok('Welcome to server!');
  }

  static Future<Response> _toursGetHandler(Request request) async {
    return Response.ok(
      _encode(
        await DatabaseProvider.selectAll(from: Table.tours),
      ),
    );
  }

  static Future<Response> _clientsGetHandler(Request request) async {
    return Response.ok(
      _encode(
        await DatabaseProvider.selectAll(from: Table.clients),
      ),
    );
  }

  static Future<Response> _tourAgentsGetHandler(Request request) async {
    return Response.ok(
      _encode(
        await DatabaseProvider.selectAll(from: Table.tourAgents),
      ),
    );
  }

  static Future<Response> _clientsPostHadler(Request request) async {
    try {
      final data = await _decode(request);
      return Response.ok(
        _encode(
          await DatabaseProvider.addItem(
            data: data,
            to: Table.clients,
          ),
        ),
      );
    } catch (e) {
      return Response(400);
    }
  }

  static Future<Response> _toursPostHadler(Request request) async {
    try {
      final data = await _decode(request);
      return Response.ok(
        _encode(
          await DatabaseProvider.addItem(
            data: data,
            to: Table.tours,
          ),
        ),
      );
    } catch (e) {
      return Response(400);
    }
  }

  static Future<Response> _tourAgentsPostHadler(Request request) async {
    try {
      final data = await _decode(request);
      return Response.ok(
        _encode(
          await DatabaseProvider.addItem(
            data: data,
            to: Table.tourAgents,
          ),
        ),
      );
    } catch (e) {
      return Response(400);
    }
  }

  Future<void> _connectToDatabase() async {
    if (await File.fromUri(Uri.parse('.env')).exists()) {
      final filename = '.env';

      final env = dotenv.DotEnv();
      env.load([filename]);

      final host = env['DB_HOST'];
      final user = env['DB_USER'];
      final pass = env['DB_PASS'];
      final name = env['DB_NAME'];
      final port = env['DB_PORT'];

      if (host != null &&
          user != null &&
          pass != null &&
          name != null &&
          port != null) {
        await DatabaseProvider.init(
          host: host,
          user: user,
          pass: pass,
          name: name,
          port: int.parse(port),
        );
      }
    }
  }

  Future<void> start() async {
    // Use any available host or container IP (usually `0.0.0.0`).
    final ip = InternetAddress.anyIPv4;

    await _connectToDatabase();

    // Configure a pipeline that logs requests.
    final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

    // For running in containers, we respect the PORT environment variable.
    final port = int.parse(Platform.environment['PORT'] ?? '8080');
    final server = await serve(handler, ip, port);
    print('Server listening at http://${server.address.host}:${server.port}');
  }
}
