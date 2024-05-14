import 'package:injectable/injectable.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../../../application/exceptions/service_exception.dart';
import '../../../application/exceptions/user_not_found_exception.dart';
import '../../../application/helpers/jwt_helper.dart';
import '../../../application/logger/i_logger.dart';
import '../../../entities/user.dart';
import '../data/i_user_repository.dart';
import '../view_models/user_update_token_device_input_model.dart';
import '../view_models/refresh_token_view_model.dart';
import '../view_models/update_url_avatar_view_model.dart';
import '../view_models/user_confirm_input_model.dart';
import '../view_models/user_refresh_token_input_model.dart';
import '../view_models/user_save_input_model.dart';
import 'i_user_service.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  IUserRepository userRepository;
  ILogger log;

  UserService({
    required this.userRepository,
    required this.log,
  });

  @override
  Future<User> createUser(UserSaveInputModel user) {
    final userEntity = User(
      email: user.email,
      password: user.password,
    );

    return userRepository.createUser(userEntity);
  }

  @override
  Future<User> loginWithEmailAndPassword(
    String email,
    String password,
  ) =>
      userRepository.loginWithEmailAndPassword(
        email,
        password,
      );

  // @override
  // Future<User> loginWithSocial(
  //   String email,
  //   String avatar,
  //   String socialType,
  //   String socialKey,
  // ) async {
  //   try {
  //     return await userRepository.loginByEmailSocialKey(
  //       email,
  //       socialKey,
  //       socialType,
  //     );
  //   } on UserNotFoundException catch (e) {
  //     log.error('User not found, creating new user', e);

  //     final user = User(
  //       email: email,
  //       imageAvatar: avatar,
  //       registerType: socialType,
  //       socialKey: socialKey,
  //       password: DateTime.now().toString(),
  //     );

  //     return await userRepository.createUser(user);
  //   }
  // }

  @override
  Future<String> confirmLogin(UserConfirmInputModel inputModel) async {
    final refreshToken = JwtHelper.refreshToken(inputModel.accessToken);

    return refreshToken;
  }

  @override
  Future<RefreshTokenViewModel> refreshToken(
    UserRefreshTokenInputModel model,
  ) async {
    _validateRefreshToken(model);
    final newAccessToken = JwtHelper.generateJWT(model.user);
    final newRefreshToken = JwtHelper.refreshToken(
      newAccessToken.replaceAll('Bearer', ''),
    );

    final user = User(
      id: model.user,
    );

    await userRepository.updateRefreshToken(user);

    return RefreshTokenViewModel(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    );
  }

  void _validateRefreshToken(UserRefreshTokenInputModel model) {
    try {
      final refreshToken = model.refreshToken.split(' ');

      if (refreshToken.length != 2 || refreshToken.first != 'Bearer') {
        log.error('Invalid Refresh Token');
        throw ServiceException('Invalid Refresh Token');
      }

      final refreshTokenClaim = JwtHelper.getClaims(refreshToken.last);
      refreshTokenClaim.validate(issuer: model.accessToken);
    } on ServiceException {
      rethrow;
    } on JwtException {
      log.error('Invalid Refresh Token');
      throw ServiceException('Invalid Refresh Token');
    } catch (e) {
      throw ServiceException('Error validating refresh token');
    }
  }

  @override
  Future<User> findById(int id) => userRepository.findById(id);

  
}
