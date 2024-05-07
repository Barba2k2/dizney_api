// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:dizney_api/application/exceptions/user_exists_exceptions.dart';
import 'package:dizney_api/modules/user/service/i_user_service.dart';
import 'package:dizney_api/modules/user/view_models/user_save_input_model.dart';

import '../../../application/logger/i_logger.dart';

part 'auth_controller.g.dart';

@Injectable()
class AuthController {
  IUserService userService;
  ILogger log;

  AuthController({
    required this.userService,
    required this.log,
  });

  @Route.post('/register')
  Future<Response> saveUser(Request request) async {
    try {
      final userModel = UserSaveInputModel(
        await request.readAsString(),
      );

      await userService.createUser(userModel);

      return Response.ok(
        jsonEncode(
          {
            'message': 'Succefully registred!!',
          },
        ),
      );
    } on UserExistsExecptions {
      return Response(
        400,
        body: jsonEncode(
          {
            'message': 'User already exists on database!!',
          },
        ),
      );
    } catch (e) {
      log.error('Error on register user', e);
      return Response.internalServerError();
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
