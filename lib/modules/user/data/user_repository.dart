import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import '../../../application/database/i_database_connection.dart';
import '../../../application/exceptions/database_exception.dart';
import '../../../application/exceptions/user_exists_exceptions.dart';
import '../../../application/helpers/cryity_helper.dart';
import '../../../application/logger/i_logger.dart';
import '../../../entities/user.dart';
import 'i_user_repository.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  final IDatabaseConnection connection;
  final ILogger log;

  UserRepository({
    required this.connection,
    required this.log,
  });

  @override
  Future<User> createUser(User user) async {
    late final MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final query = '''
        INSERT usuario(email, tipo_cadastro, img_avatar, senha, fornecedor_id, social_id)
        values(?, ?, ?, ?, ?, ?)
      ''';

      final result = await conn.query(query, [
        user.email,
        user.registerType,
        user.imageAvatar,
        CriptyHelper.generatySha256Hash(user.password ?? ''),
        user.supplierId,
        user.socialKey,
      ]);

      final userId = result.insertId;

      return user.copyWith(id: userId, password: null);
    } on MySqlException catch (e, s) {
      if (e.message.contains('usuario.email_UNIQUE')) {
        log.error('Email already exists in the database', e, s);
        throw UserExistsExecptions();
      }

      log.error('Error on create user', e, s);

      throw DatabaseException(
        message: 'Error on create user',
        exception: e,
      );
    } finally {
      await conn?.close();
    }
  }
}
