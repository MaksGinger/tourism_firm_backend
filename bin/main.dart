import 'server.dart';

void main(List<String> args) async {
  final server = Server();
  await server.start();
}
