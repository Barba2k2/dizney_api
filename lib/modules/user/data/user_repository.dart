import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import '../../../application/database/i_database_connection.dart';
import '../../../application/exceptions/database_exception.dart';
import '../../../application/exceptions/user_exists_exceptions.dart';
import '../../../application/exceptions/user_not_found_exception.dart';
import '../../../application/helpers/cryity_helper.dart';
import '../../../application/logger/i_logger.dart';
import '../../../entities/user.dart';
// import '../view_models/platform.dart';
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

      final result = await conn.query(
        query,
        [
          user.email,
          CriptyHelper.generatySha256Hash(user.password ?? ''),
        ],
      );

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

  @override
  Future<User> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      var query = 'SELECT * FROM usuario WHERE email = ? AND senha = ?';

      final result = await conn.query(
        query,
        [
          email,
          CriptyHelper.generatySha256Hash(password),
        ],
      );

      if (result.isEmpty) {
        log.error('User or password invalid');
        throw UserNotFoundException(message: 'User or password invalid');
      } else {
        final userSqlData = result.first;

        return User(
          id: userSqlData['id'] as int,
          email: userSqlData['email'],
        );
      }
    } on MySqlException catch (e, s) {
      log.error('Erro on try login', e, s);

      throw DatabaseException(message: e.message);
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<User> loginByEmailSocialKey(
    String email,
    String socialKey,
    String socialType,
  ) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final result = await conn.query(
        'SELECT * FROM usuario WHERE email = ?',
        [
          email,
        ],
      );

      if (result.isEmpty) {
        log.error('User not found');
        throw UserNotFoundException(message: 'User not found');
      } else {
        final dataMySql = result.first;

        return User(
          id: dataMySql['id'] as int,
          email: dataMySql['email'],
        );
      }
    } on MySqlException catch (e, s) {
      log.error('Erro on try login with social network', e, s);

      throw DatabaseException(message: e.message);
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<void> updateUserDeviceTokenAndRefreshToken(User user) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final setParams = {};

      final query = '''
        UPDATE ususario SET ${setParams.keys.elementAt(0)} = ? 
        refresh_token = ? 
        WHERE id = ?
      ''';

      await conn.query(
        query,
        [
          setParams.values.elementAt(0),
          user.id!,
        ],
      );
    } on MySqlException catch (e, s) {
      log.error('Error on confirm login', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<void> updateRefreshToken(User user) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      await conn.query(
        'UPDATE usuario SET refresh_token = ? WHERE id = ?',
        [
          user.id!,
        ],
      );
    } on MySqlException catch (e, s) {
      log.error('Error on update refresh token', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<User> findById(int id) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final result = await conn.query(
        'SELECT * FROM usuario WHERE id = ?',
        [
          id,
        ],
      );

      if (result.isEmpty) {
        log.error('User not found with ID[$id]');
        throw UserNotFoundException(message: 'User not found with ID[$id]');
      } else {
        final dataMySql = result.first;

        return User(
          id: dataMySql['id'] as int,
          email: dataMySql['email'],
        );
      }
    } on MySqlException catch (e, s) {
      log.error('Error on search user by ID', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<void> updateUrlAvatar(int id, String urlAvatar) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      await conn.query(
        'UPDATE usuario SET img_avatar = ? WHERE id = ?',
        [
          urlAvatar,
          id,
        ],
      );
    } on MySqlException catch (e, s) {
      log.error('Error on update avatar', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
