import '../../../entities/user.dart';

abstract class IUserRepository {
  Future<User> createUser(User user);
  Future<User> loginWithEmailAndPassword(String email, String password, bool supplierUser);
}
