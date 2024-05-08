import 'dart:async';
import 'dart:convert';

import 'package:dizney_api/modules/user/view_models/update_url_avatar_view_model.dart';
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
            'register_type': userData.registerType,
            'img_avatar': userData.imageAvatar,
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

  @Route.put('/avatar')
  Future<Response> updateAvatar(Request request) async {
    try {
      final userId = int.parse(request.headers['user']!);

      final updateUrlAvatarViewModel = UpdateUrlAvatarViewModel(
        userId: userId,
        dataRequest: await request.readAsString(),
      );

      final user = await userService.updateAvatar(updateUrlAvatarViewModel);

      return Response.ok(
        jsonEncode(
          {
            'email': user.email,
            'register_type': user.registerType,
            'img_avatar': user.imageAvatar,
          },
        ),
      );
    } catch (e, s) {
      log.error('Error on update avatar', e, s);
      return Response.internalServerError(
        body: jsonEncode(
          {
            'message': 'Error on update avatar',
          },
        ),
      );
    }
  }

  Router get router => _$UserControllerRouter(this);
}
