import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../application/logger/i_logger.dart';
import '../service/i_user_service.dart';

part 'user_controller.g.dart';

@Injectable()
class UserController {
  IUserService userService;
  ILogger log;

  UserController({
    required this.userService,
    required this.log,
  });

  @Route.get('/')
  Future<Response> findByToken(Request request) async {
    try {
      final user = int.parse(request.headers['user']!);
      final userData = await userService.findById(user);

      return Response.ok(
        jsonEncode(
          {
            'email': userData.email,
          },
        ),
      );
    } catch (e, s) {
      log.error('Error on find user', e, s);
      return Response.internalServerError(
        body: jsonEncode(
          {
            'message': 'Error on find user',
          },
        ),
      );
    }
  }

  Router get router => _$UserControllerRouter(this);
}
