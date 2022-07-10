import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

abstract class Routes {
  static const String root = '/';
  static const String tours = '/tours';
  static const String clients = '/clients';
  static const String tourAgents = '/tour_agents';
}

mixin JsonConverting {
  final JsonDecoder _decoder = JsonDecoder();
  final JsonEncoder _encoder = JsonEncoder();

  dynamic _decode(Request request) async =>
      _decoder.convert(await request.readAsString());
  String _encode(Object? data) => _encoder.convert(data);
}

class Server with JsonConverting {
  final _router = Router()
    ..get(Routes.root, _rootHandler)
    ..get('/echo/<message>', _echoHandler)
    ..get(Routes.tours, _toursHandler)
    ..get(Routes.clients, _clientsHandler)
    ..get(Routes.tourAgents, _tourAgentsHandler);

  static Response _rootHandler(Request request) {
    return Response.ok('Welcome to server!');
  }

  static Response _echoHandler(Request request) {
    final message = request.params['message'];
    return Response.ok('$message\n');
  }

  static Response _toursHandler(Request request) {
    return Response.ok('tours!');
  }

  static Response _clientsHandler(Request request) {
    return Response.ok('clients!');
  }

  static Response _tourAgentsHandler(Request request) {
    return Response.ok('tour agents!');
  }

  Future<void> start() async {
    // Use any available host or container IP (usually `0.0.0.0`).
    final ip = InternetAddress.anyIPv4;

    // Configure a pipeline that logs requests.
    final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

    // For running in containers, we respect the PORT environment variable.
    final port = int.parse(Platform.environment['PORT'] ?? '8080');
    final server = await serve(handler, ip, port);
    print('Server listening at http://${server.address.host}:${server.port}');
  }
}
