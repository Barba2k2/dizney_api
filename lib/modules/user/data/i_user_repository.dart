import '../../../entities/user.dart';

abstract class IUserRepository {
  Future<User> createUser(User user);
  Future<User> loginWithEmailAndPassword(
      String email, String password, bool supplierUser);
  Future<User> loginByEmailSocialKey(
      String email, String socialKey, String socialType);
  Future<void> updateUserDeviceTokenAndRefreshToken(User user);
  Future<void> updateRefreshToken(User user);
  Future<User> findById(int id);
}
