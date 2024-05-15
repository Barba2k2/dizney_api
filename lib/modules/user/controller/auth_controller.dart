import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../application/exceptions/user_exists_exceptions.dart';
import '../../../application/exceptions/user_not_found_exception.dart';
import '../../../application/helpers/jwt_helper.dart';
import '../../../application/logger/i_logger.dart';
import '../../../entities/user.dart';
import '../view_models/user_confirm_input_model.dart';
import '../view_models/user_refresh_token_input_model.dart';
import '../service/i_user_service.dart';
import '../view_models/login_view_model.dart';
import '../view_models/user_save_input_model.dart';

part 'auth_controller.g.dart';

@Injectable()
class AuthController {
  IUserService userService;
  ILogger log;

  AuthController({
    required this.userService,
    required this.log,
  });

  @Route.post('/login')
  Future<Response> login(Request request) async {
    try {
      final loginViewModel = LoginViewModel(await request.readAsString());

      User user;

      user = await userService.loginWithEmailAndPassword(
        loginViewModel.email,
        loginViewModel.password,
      );

      final accessToken = JwtHelper.generateJWT(
        user.id!,
      );

      return Response.ok(
        jsonEncode({
          'access_token': accessToken,
          'user': {
            'id': user.id,
            'username': user.username,
            'email': user.email,
            'image': user.image,
          }
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } on UserNotFoundException {
      return Response.forbidden(
        jsonEncode(
          {
            'message': 'User or password invalid!',
          },
        ),
      );
    } catch (e, s) {
      log.error('Error on login', e, s);
      return Response.internalServerError(
        body: jsonEncode(
          {
            'message': 'Error on login!',
          },
        ),
      );
    }
  }

  @Route.post('/register')
  Future<Response> saveUser(Request request) async {
    try {
      final requestData = await request.readAsString();
      print('Received data: $requestData');
      final userModel = UserSaveInputModel(requestData);

      if (userModel.email.isEmpty ||
          userModel.password.isEmpty ||
          userModel.timezone == null ||
          userModel.firstname.isEmpty ||
          userModel.lastname.isEmpty ||
          userModel.username.isEmpty) {
        log.info('Recieved user data: ${await request.readAsString()}');
        return Response(
          400,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
            {
              'message':
                  'Missing required fields. Please ensure all required fields are provided.',
            },
          ),
        );
      }

      await userService.createUser(userModel);

      return Response.ok(
        jsonEncode(
          {
            'message': 'Successfully registered!',
          },
        ),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    } on UserExistsExceptions {
      return Response(
        400,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'message': 'User already exists in the database!',
          },
        ),
      );
    } catch (e) {
      log.error('Error on register user', e);
      return Response.internalServerError(
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'message': 'Error on registering user',
          },
        ),
      );
    }
  }

  @Route('PATCH', '/confirm')
  Future<Response> confirmLogin(Request request) async {
    try {
      final user = int.parse(request.headers['user']!);

      final token = JwtHelper.generateJWT(user).replaceAll(
        'Bearer ',
        '',
      );

      final inputModel = UserConfirmInputModel(
        userId: user,
        accessToken: token,
        data: await request.readAsString(),
      );

      final refreshToken = await userService.confirmLogin(inputModel);

      return Response.ok(
        jsonEncode(
          {
            'access_token': 'Bearer $token',
            'refresh_token': refreshToken,
          },
        ),
      );
    } catch (e) {
      log.error('Error on confirm login', e);
      return Response.internalServerError();
    }
  }

  @Route.put('/refresh')
  Future<Response> refreshToken(Request request) async {
    try {
      final user = int.parse(request.headers['user']!);

      final accessToken = request.headers['access_token']!;

      final model = UserRefreshTokenInputModel(
        user: user,
        accessToken: accessToken,
        dataRequest: await request.readAsString(),
      );

      final userRefreshToken = await userService.refreshToken(model);

      return Response.ok(
        jsonEncode(
          {
            'access_token': userRefreshToken.accessToken,
            'refresh_token': userRefreshToken.refreshToken,
          },
        ),
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode(
          {
            'message': 'Error on updtade access_token',
          },
        ),
      );
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
