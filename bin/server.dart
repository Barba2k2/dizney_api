import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import 'package:dizney_api/application/config/application_config.dart';
import 'package:dizney_api/application/middlewares/cors/cors_middlewares.dart';
import 'package:dizney_api/application/middlewares/defaultContentType/default_content_type.dart';
import 'package:dizney_api/application/middlewares/security/security_middleware.dart';

const _hostname = '0.0.0.0';

void main(List<String> args) async {
  var parser = ArgParser()..addOption('port', abbr: 'p');
  var result = parser.parse(args);

  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '8080';
  var port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    exitCode = 64;
    return;
  }

  //# AppConfig
  final router = Router();
  router.get(
    '/health',
    (shelf.Request request) {
      return shelf.Response.ok(
        jsonEncode(
          {
            'status': 'ok',
          },
        ),
      );
    },
  );
  final appConfig = ApplicationConfig();
  await appConfig.loadConfigApplication(router);

  final getIt = GetIt.I;

  final handler = const shelf.Pipeline()
      .addMiddleware(CorsMiddlewares().handler)
      .addMiddleware(
        DefaultContentType('application/josn; charset=utf-8').handler,
      )
      .addMiddleware(
        SecurityMiddleware(getIt.get()).handler,
      )
      .addMiddleware(shelf.logRequests())
      .addHandler(router);

  final server = await io.serve(handler, _hostname, port);
  print('Serving at http://${server.address.host}:${server.port}');
}
