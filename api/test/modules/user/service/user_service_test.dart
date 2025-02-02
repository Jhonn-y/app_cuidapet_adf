import 'package:cuidapet_api/application/exeptions/service_exception.dart';
import 'package:cuidapet_api/application/exeptions/user_not_found_exception.dart';
import 'package:cuidapet_api/application/helpers/jwt_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/i_user_repo.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/service/user_service.dart';
import 'package:cuidapet_api/modules/user/view_models/refresh_token_view_model.dart';
import 'package:cuidapet_api/modules/user/view_models/user_refresh_token_input_model.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../core/log/mock_logger.dart';

class MockUserRepo extends Mock implements IUserRepo {}

class DotEnvConfig {
  static String refreshTokenNotBeforeHours =
      DotEnv()['refresh_token_not_before_hours'] ?? 'default_value';

  static void updateRefreshTokenNotBeforeHours(String value) {
    refreshTokenNotBeforeHours = value;
  }
}

void main() {
  late IUserRepo userRepo;
  late ILogger log;
  late IUserService userService;

  setUp(() {
    userRepo = MockUserRepo();
    log = MockLogger();
    registerFallbackValue(User());
    userService = UserService(userRepo: userRepo, log: log);
  });

  group('Group test service loginWithEmailAndPassword', () {
    test('Should login with email and password and return success', () async {
      //Arrange
      final id = 1;
      final email = 'test@gmail.com';
      final password = "123123";
      final supplierUser = false;
      final userMock = User(id: id, email: email);

      when(() => userRepo.loginWithEmailPassword(email, password, supplierUser))
          .thenAnswer((_) async => userMock);

      //Act
      final user = await userService.loginWithEmailPassword(
          email, password, supplierUser);

      //Assert
      expect(user, userMock);
      verify(() =>
              userRepo.loginWithEmailPassword(email, password, supplierUser))
          .called(1);
    });

    test(
        'Should login with email and password and return UserNotFoundException',
        () async {
      //Arrange
      final email = 'test@gmail.com';
      final password = "123123";
      final supplierUser = false;

      when(() => userRepo.loginWithEmailPassword(email, password, supplierUser))
          .thenThrow(UserNotFoundException());

      //Act
      final call = userService.loginWithEmailPassword;

      //Assert
      expect(
        () => call(email, password, supplierUser),
        throwsA(
          isA<UserNotFoundException>(),
        ),
      );
      verify(() =>
              userRepo.loginWithEmailPassword(email, password, supplierUser))
          .called(1);
    });
  });

  group('Group test service loginWithSocial', () {
    test('Should login social and return success', () async {
      //Arrange
      final email = 'test@gmail.com';
      final socialKey = '123';
      final socialType = 'Facebook';

      final userReturnLogin = User(
        id: 1,
        email: email,
        socialKey: socialKey,
        registerType: socialType,
      );

      when(() => userRepo.loginWithSocialKey(email, socialKey, socialType))
          .thenAnswer((_) async => userReturnLogin);
      //Act
      final user = await userService.loginWithSocialKey(
          email, '', socialKey, socialType);

      //Assert
      expect(user, userReturnLogin);
      verify(() => userRepo.loginWithSocialKey(email, socialKey, socialType))
          .called(1);
    });

    test('Should login social and created new user', () async {
      //Arrange
      final email = 'test@gmail.com';
      final socialKey = '123';
      final socialType = 'Facebook';

      final userCreated = User(
        id: 1,
        email: email,
        socialKey: socialKey,
        registerType: socialType,
      );

      when(() => userRepo.loginWithSocialKey(email, socialKey, socialType))
          .thenThrow(UserNotFoundException());

      when(() => userRepo.createUser(any()))
          .thenAnswer((_) async => userCreated);
      //Act
      final user = await userService.loginWithSocialKey(
          email, '', socialKey, socialType);

      //Assert
      expect(user, userCreated);
      verify(() => userRepo.loginWithSocialKey(email, socialKey, socialType))
          .called(1);
      verify(() => userRepo.createUser(any())).called(1);
    });
  });

  // ATIVAR AS VARIAVEIS E METODOS NO ARQUIVO JWT_HELPER
  group('Group test refresh Token', () {
    test('Should resfresh token with success', () async {
      //Arrange
      DotEnvConfig.refreshTokenNotBeforeHours = '0';
      final userId = 1;
      final accessToken = JwtHelper.generateJwt(userId, null);
      final refreshToken = JwtHelper.refreshToken(accessToken);
      final model = UserRefreshTokenInputModel(
          user: userId,
          accessToken: accessToken,
          dataRequest: '{"refresh_token": "$refreshToken"}');

      when(() => userRepo.updateRefreshToken(any())).thenAnswer((_) async => _);

      //Act
      final responseToken = await userService.refreshToken(model);
      //Assert
      expect(responseToken, isA<RefreshTokenViewModel>());
      expect(responseToken.accessToken, isNotEmpty);
      expect(responseToken.refreshToken, isNotEmpty);
      verify(() => userRepo.updateRefreshToken(any())).called(1);
    });

    test('Should resfresh token with ServiceException', () async {
      //Arrange
      final model = UserRefreshTokenInputModel(
          user: 1,
          accessToken: 'accessToken',
          dataRequest: '{"refresh_token": ""}');
      //Act
      final call = userService.refreshToken;
      //Assert
      expect(() => call(model), throwsA(isA<ServiceException>()));
    });

    test('Should resfresh token JWT but return JwtException', () async {
      //Arrange
      final userId = 1;
      final accessToken = JwtHelper.generateJwt(userId, null);
      final refreshToken = JwtHelper.refreshToken('123');
      final model = UserRefreshTokenInputModel(
          user: userId,
          accessToken: accessToken,
          dataRequest: '{"refresh_token": "$refreshToken"}');

      final call = userService.refreshToken;
      //Assert
      expect(() => call(model), throwsA(isA<ServiceException>()));
    });
  });
}
