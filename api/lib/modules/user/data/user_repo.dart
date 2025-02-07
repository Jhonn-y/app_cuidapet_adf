import 'package:cuidapet_api/application/database/i_database_conn.dart';
import 'package:cuidapet_api/application/exeptions/database_exception.dart';
import 'package:cuidapet_api/application/exeptions/user_exists_exception.dart';
import 'package:cuidapet_api/application/exeptions/user_not_found_exception.dart';
import 'package:cuidapet_api/application/helpers/crypt_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/i_user_repo.dart';
import 'package:cuidapet_api/modules/user/view_models/platform_enum.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

@LazySingleton(as: IUserRepo)
class UserRepo implements IUserRepo {
  final IDatabaseConn connection;
  final ILogger logger;

  UserRepo({required this.connection, required this.logger});

  @override
  Future<User> createUser(User user) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final query =
          'insert into usuario(email,senha,tipo_cadastro,img_avatar, fornecedor_id, social_id) values (?,?,?,?,?,?)';

      // USUARIO NAO CADASTRA NO BANCO DE DADOS, POSSIVEL PROBLEMA COM A VERSAO DO MYSQL

      final result = await conn.query(query, [
        user.email,
        CryptHelper.generateSHA256Hash(user.password ?? ''),
        user.registerType,
        user.imageAvatar,
        user.supplierID,
        user.socialKey,
      ]);

      final userID = result.insertId;
      return user.copyWith(id: userID, password: '');
    } on MySqlException catch (e) {
      if (e.message.contains('usuario.email_UNIQUE')) {
        logger.error('Email ja utilizado', e);
        throw UserExistsException();
      }

      logger.error('Erro ao criar usuario', e);
      throw DatabaseException();
    } finally {
      conn?.close();
    }
  }

  @override
  Future<User> loginWithEmailPassword(
      String email, String password, bool supplierUser) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      var query = 'select * from usuario where email = ? and senha = ?';

      if (supplierUser) {
        query += ' and fornecedor_id is not null';
      } else {
        query += ' and fornecedor_id is null';
      }

      final result = await conn.query(query, [
        email,
        CryptHelper.generateSHA256Hash(password),
      ]);

      if (result.isEmpty) {
        logger.error('Usuario ou senha invalidos');
        throw UserNotFoundException();
      } else {
        final userData = result.first;
        return User(
          id: userData['id'] as int,
          email: userData['email'],
          registerType: userData['tipo_cadastro'],
          iosToken: (userData['ios_token'] as Blob?)?.toString(),
          androidToken: (userData['android_token'] as Blob?)?.toString(),
          refreshToken: (userData['refresh_token'] as Blob?)?.toString(),
          imageAvatar: (userData['img_avatar'] as Blob?)?.toString(),
          supplierID: userData['fornecedor_id'] as int,
        );
      }
    } on MySqlException catch (e) {
      logger.error('erro ao realizar login', e);
      throw DatabaseException(message: e.message);
    } finally {
      conn?.close();
    }
  }

  @override
  Future<User> loginWithSocialKey(
      String email, String socialKey, String socialType) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final result =
          await conn.query('select * from usuario where email = ?', [email]);

      if (result.isEmpty) {
        throw UserNotFoundException();
      } else {
        final dataMysql = result.first;
        if (dataMysql['social_id'] == null ||
            dataMysql['social_id'] != socialKey) {
          await conn.query(
              ' update usuario set social_id = ?, tipo_cadastro = ? where id = ?',
              [socialKey, socialType, dataMysql['id']]);
        }
        return User(
          id: dataMysql['id'] as int,
          email: dataMysql['email'],
          registerType: dataMysql['tipo_cadastro'],
          iosToken: (dataMysql['ios_token'] as Blob?)?.toString(),
          androidToken: (dataMysql['android_token'] as Blob?)?.toString(),
          refreshToken: (dataMysql['refresh_token'] as Blob?)?.toString(),
          imageAvatar: (dataMysql['img_avatar'] as Blob?)?.toString(),
          supplierID: dataMysql['fornecedor_id'] as int,
        );
      }
    } on MySqlException catch (e) {
      logger.error('erro ao realizar login', e);
      throw DatabaseException(message: e.message);
    } finally {
      conn?.close();
    }
  }

  @override
  Future updateUserDeviceTokenAndRefreshToken(User user) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final setParams = {};

      if (user.iosToken != null) {
        setParams.putIfAbsent('ios_token', () => user.iosToken);
      } else {
        setParams.putIfAbsent('android_token', () => user.androidToken);
      }

      final query = '''
        update usuario
        set 
          ${setParams.keys.elementAt(0)}
          refresh_token = ?
        where id = ?
      ''';

      await conn.query(query, [
        setParams.values.elementAt(0),
        user.refreshToken!,
        user.id!,
      ]);
    } on MySqlException catch (e) {
      logger.error('Erro ao atualizar token e refresh token', e);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future updateRefreshToken(User user) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      await conn.query('update usuario set refresh_token = ? where id = ?', [
        user.refreshToken!,
        user.id!,
      ]);
    } on MySqlException catch (e) {
      logger.error("erro ao atualizar token");
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<User> findByID(int id) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final result =
          await conn.query('select * from usuario where id = ?', [id]);

      if (result.isEmpty) {
        throw UserNotFoundException();
      } else {
        final dataMysql = result.first;

        return User(
          id: dataMysql['id'] as int,
          email: dataMysql['email'],
          registerType: dataMysql['tipo_cadastro'],
          iosToken: (dataMysql['ios_token'] as Blob?)?.toString(),
          androidToken: (dataMysql['android_token'] as Blob?)?.toString(),
          refreshToken: (dataMysql['refresh_token'] as Blob?)?.toString(),
          imageAvatar: (dataMysql['img_avatar'] as Blob?)?.toString(),
          supplierID: dataMysql['fornecedor_id'],
        );
      }
    } on MySqlException catch (e) {
      logger.error('Erro ao buscar usuario', e);
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
          'update usuario set img_avatar = ? where id = ?', [urlAvatar, id]);
    } on MySqlException catch (e) {
      logger.error('Erro ao atualizar avatar do usuario', e);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<void> updateDeviceToken(
      int id, String deviceToken, PlatformEnum platform) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      var setToken = '';

      if (platform == PlatformEnum.ios) {
        setToken = 'ios_token = ?';
      } else {
        setToken = 'android_token = ?';
      }

      final query = 'update usuario set $setToken where id = ?';
      await conn.query(query, [deviceToken, id]);
    } on MySqlException catch (e) {
      logger.error('Erro ao atualizar device token do usuario', e);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
