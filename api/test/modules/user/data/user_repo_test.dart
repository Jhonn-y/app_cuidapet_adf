import 'dart:convert';

import 'package:cuidapet_api/application/exeptions/database_exception.dart';
import 'package:cuidapet_api/application/exeptions/user_exists_exception.dart';
import 'package:cuidapet_api/application/exeptions/user_not_found_exception.dart';
import 'package:cuidapet_api/application/helpers/crypt_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/user_repo.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/mysql/mock_database_connection.dart';
import '../../../core/mysql/mock_database_exception.dart';
import '../../../core/mysql/mock_results.dart';

void main() {
  late MockDatabaseConnection database;
  late ILogger log;
  late UserRepo userRepository;

  setUp(() {
    database = MockDatabaseConnection();
    log = MockLogger();
    userRepository = UserRepo(connection: database, logger: log);
  });

  group('Group test findById', () {
    test('Should return id', () async {
      final id = 1;
      final userFixtureDB = FixtureReader.getJsonData(
          'modules/user/data/fixture/find_by_id_sucess_fixture.json');
      final mySqlResults = MockResults(userFixtureDB, [
        "ios_token",
        "android_token",
        "refresh_token",
        "img_avatar",
      ]);
      database.mockQuery(mySqlResults);

      final user = await userRepository.findByID(id);

      expect(user, isA<User>());
    });

    test('Should return exception UserNotFoundException ', () async {
      //Arrange
      final id = 1;
      final mockResults = MockResults();
      //Act
      database.mockQuery(mockResults, [id]);
      final userRepository = UserRepo(connection: database, logger: log);

      var call = userRepository.findByID;

      //Assert
      expect(() => call(id), throwsA(isA<UserNotFoundException>()));
    });
  });

  group('Group test create user', () {
    test('Should create user success', () async {
      //Arrange
      final userID = 1;
      final mockResults = MockResults();
      when(() => mockResults.insertId).thenReturn(userID);
      database.mockQuery(mockResults);

      final userInsert = User(
        email: 'test@email.com',
        password: '123123',
        registerType: 'APP',
        imageAvatar: '',
      );

      final userExpected = User(
        id: userID,
        email: 'test@email.com',
        password: '',
        registerType: 'APP',
        imageAvatar: '',
      );
      //Act
      final user = await userRepository.createUser(userInsert);

      //Assert
      expect(user, userExpected);
    });

    test('Should return DatabaseException', () async {
      //Arrange
      database.mockQueryException();
      //Act
      var call = userRepository.createUser;
      //Assert

      expect(() => call(User()), throwsA(isA<DatabaseException>()));
    });

    test('Should return UserExistsException', () async {
      //Arrange
      final exception = MockDatabaseException();
      when(() => exception.message).thenReturn('usuario.email_UNIQUE');
      database.mockQueryException(mockException: exception);
      //Act
      var call = userRepository.createUser;
      //Assert

      expect(() => call(User()), throwsA(isA<UserExistsException>()));
    });
  });

  group('Group test LoginWithEmailAndPassword', () {
    test('Should return login with email and password', () async {
      //Arrange
      final userFixtureDB = FixtureReader.getJsonData(
          'modules/user/data/fixture/login_with_email_and_password_success.json');
      final mySqlResults = MockResults(userFixtureDB, [
        "ios_token",
        "android_token",
        "refresh_token",
        "img_avatar",
      ]);

      final email = 'test@gmail.com';
      final password = '123123';
      database.mockQuery(mySqlResults, [
        email,
        CryptHelper.generateSHA256Hash(password),
      ]);
      final userMap = jsonDecode(userFixtureDB);
      final userExpected = User(
        id: userMap['id'],
        email: userMap['email'],
        registerType: userMap['tipo_cadastro'],
        iosToken: userMap['ios_token'],
        androidToken: userMap['android_token'],
        refreshToken: userMap['refresh_token'],
        imageAvatar: userMap['img_avatar'],
        supplierID: userMap['fornecedor_id'],
      );
      //Act
      final user =
          await userRepository.loginWithEmailPassword(email, password, false);

      //Assert
      expect(user, userExpected);
      //Assert
    });

    test(
        'Should login with email and password and return UserNotFoundException',
        () async {
      //Arrange
      final mySqlResults = MockResults();

      final email = 'test@gmail.com';
      final password = '123123';
      database.mockQuery(mySqlResults, [
        email,
        CryptHelper.generateSHA256Hash(password),
      ]);
      //Act
      final call = userRepository.loginWithEmailPassword;

      //Assert
      expect(() => call(email, password, false),
          throwsA(isA<UserNotFoundException>()));
      //Assert
    });
    test('Should login with email and password and return DatabaseException',
        () async {
      //Arrange

      final email = 'test@gmail.com';
      final password = '123123';
      database.mockQueryException(params: [
        email,
        CryptHelper.generateSHA256Hash(password),
      ]);
      //Act
      final call = userRepository.loginWithEmailPassword;

      //Assert
      expect(() => call(email, password, false),
          throwsA(isA<DatabaseException>()));
      //Assert
    });
  });

  group('group test LoginByEmailAndSocialKey', () {
    test('Should login with email and socialKey with success', () async {
      //Arrange
      final userFixtureDB = FixtureReader.getJsonData(
          'modules/user/data/fixture/login_with_email_and_social_key_success.json');
      final mySqlResults = MockResults(userFixtureDB, [
        "ios_token",
        "android_token",
        "refresh_token",
        "img_avatar",
      ]);

      final email = "teste@gmail.com";
      final socialKey = "123";
      final socialType = "Facebook";
      final params = [email];

      database.mockQuery(mySqlResults, params);

      final userMap = jsonDecode(userFixtureDB);
      final userExpected = User(
        id: userMap['id'],
        email: userMap['email'],
        registerType: userMap['tipo_cadastro'],
        iosToken: userMap['ios_token'],
        androidToken: userMap['android_token'],
        refreshToken: userMap['refresh_token'],
        imageAvatar: userMap['img_avatar'],
        supplierID: userMap['fornecedor_id'],
      );

      //Act
      final user = await userRepository.loginWithSocialKey(
        email,
        socialKey,
        socialType,
      );

      //Assert
      expect(user, userExpected);
      database.verifyQueryNeverCalled(params: [
        socialKey,
        socialType,
        userMap['id'],
      ]);
      database.verifyQueryCalled(params: params);
    });

    test(
        'Should login with email and socialKey with success and update social_id',
        () async {
      //Arrange
      final userFixtureDB = FixtureReader.getJsonData(
          'modules/user/data/fixture/login_with_email_and_social_key_success.json');
      final mySqlResults = MockResults(userFixtureDB, [
        "ios_token",
        "android_token",
        "refresh_token",
        "img_avatar",
      ]);

      final userMap = jsonDecode(userFixtureDB);
      final email = "teste@gmail.com";
      final socialKey = "G123";
      final socialType = "Google";
      final paramsSelect = [email];
      final paramsUpdate = <Object>[
        socialKey,
        socialType,
        userMap['id'],
      ];

      database.mockQuery(mySqlResults, paramsSelect);
      database.mockQuery(mySqlResults, paramsUpdate);

      final userExpected = User(
        id: userMap['id'],
        email: userMap['email'],
        registerType: userMap['tipo_cadastro'],
        iosToken: userMap['ios_token'],
        androidToken: userMap['android_token'],
        refreshToken: userMap['refresh_token'],
        imageAvatar: userMap['img_avatar'],
        supplierID: userMap['fornecedor_id'],
      );

      //Act
      final user = await userRepository.loginWithSocialKey(
        email,
        socialKey,
        socialType,
      );

      //Assert
      expect(user, userExpected);

      database.verifyQueryCalled(params: paramsSelect);
      database.verifyQueryCalled(params: paramsUpdate);
    });

    test(
        'Should login with email and socialKey and throws UserNotFoundException',
        () async {
      //Arrange
      final mockResults = MockResults();
      final email = "teste@gmail.com";
      final socialKey = "G123";
      final socialType = "Google";
      final paramsSelect = [email];

      database.mockQuery(mockResults, paramsSelect);

      //Act
      final call = userRepository.loginWithSocialKey;

      //Assert
      expect(
          () => call(
                email,
                socialKey,
                socialType,
              ),
          throwsA(isA<UserNotFoundException>()));
      await Future.delayed(Duration(milliseconds: 200));

      database.verifyQueryCalled(params: paramsSelect);
    });
    
    test(
        'Should login with email and socialKey and throws DatabaseException',
        () async {
      //Arrange
      final email = "teste@gmail.com";
      final socialKey = "G123";
      final socialType = "Google";
      final paramsSelect = [email];

      database.mockQueryException(params:  paramsSelect);

      //Act
      final call = userRepository.loginWithSocialKey;

      //Assert
      expect(
          () => call(
                email,
                socialKey,
                socialType,
              ),
          throwsA(isA<DatabaseException>()));
      await Future.delayed(Duration(milliseconds: 200));

      database.verifyQueryCalled(params: paramsSelect);
    });
  });
}
