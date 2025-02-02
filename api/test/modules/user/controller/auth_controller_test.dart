import 'dart:convert';

import 'package:cuidapet_api/application/exeptions/user_not_found_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/controller/user_auth_controller.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/shelf/mock_shelf_request.dart';
import 'mock/mock_user_service.dart';

void main() {
  late IUserService userService;
  late ILogger logger;
  late UserAuthController authController;
  late Request request;

  setUp(() {
    userService = MockUserService();
    logger = MockLogger();
    authController = UserAuthController(userService: userService, log: logger);
    request = MockShelfRequest();
  });

  group('Group test authController email and password', () {
    test('Should request return success', () async {
      //Arrange
      final loginFixtureReader = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_email_and_password_request.json');

      final loginRequestData = jsonDecode(loginFixtureReader);
      final login = loginRequestData['login'];
      final password = loginRequestData['password'];
      final supplierUser = loginRequestData['supplier_user'];

      when(() => request.readAsString())
          .thenAnswer((_) async => loginFixtureReader);

      when(() =>
              userService.loginWithEmailPassword(login, password, supplierUser))
          .thenAnswer((_) async => User(
                id: 1,
                email: login,
              ));
      //Act
      final response = await authController.login(request);
      //Assert
      final responseData = jsonDecode(await response.readAsString());
      expect(response.statusCode, 200);
      expect(responseData['access_token'], isNotEmpty);
      verify(() =>
              userService.loginWithEmailPassword(login, password, supplierUser))
          .called(1);
      verifyNever(
          () => userService.loginWithSocialKey(any(), any(), any(), any()));
    });

    test('Should request return UserNotFoundException', () async {
      //Arrange
      final loginFixtureReader = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_email_and_password_request.json');

      final loginRequestData = jsonDecode(loginFixtureReader);
      final login = loginRequestData['login'];
      final password = loginRequestData['password'];
      final supplierUser = loginRequestData['supplier_user'];

      when(() => request.readAsString())
          .thenAnswer((_) async => loginFixtureReader);

      when(() =>
              userService.loginWithEmailPassword(login, password, supplierUser))
          .thenThrow(UserNotFoundException());
      //Act
      final response = await authController.login(request);
      //Assert
      expect(response.statusCode, 403);
      verify(() =>
          userService.loginWithEmailPassword(login, password, supplierUser));
      verifyNever(
          () => userService.loginWithSocialKey(any(), any(), any(), any()));
    });
  });

  group('Group test authController social login', () {
    test('Should login with social and return success', () async {
      //Arrange
      final requestFixture = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_social_request.json');

      final loginRequestData = jsonDecode(requestFixture);
      final email = loginRequestData['login'];
      final avatar = loginRequestData['avatar'];
      final socialType = loginRequestData['social_type'];
      final socialKey = loginRequestData['social_key'];
      //Act
      when(() => request.readAsString())
          .thenAnswer((_) async => requestFixture);

      when(() => userService
              .loginWithSocialKey(email, avatar, socialType, socialKey))
          .thenAnswer((_) async => User(
                id: 1,
                email: email,
                imageAvatar: avatar,
                registerType: socialType,
                socialKey: socialKey,
              ));
      final response = await authController.login(request);
      //Assert
      final responseData = await jsonDecode(await response.readAsString());
      expect(response.statusCode, 200);
      expect(responseData['access_token'], isNotEmpty);
      verify(() => userService.loginWithSocialKey(
          email, avatar, socialType, socialKey)).called(1);
      verifyNever(
          () => userService.loginWithEmailPassword(any(), any(), any()));
    });

    test('Should return RequestValidationException', () async {
      //Arrange
      final requestFixture = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_social_request_validation_error.json');

      //Act
      when(() => request.readAsString())
          .thenAnswer((_) async => requestFixture);

      final response = await authController.login(request);
      //Assert
      final responseData = await jsonDecode(await response.readAsString());

      expect(response.statusCode, 400);
      expect(responseData['social_type'], 'required');
      expect(responseData['social_key'], 'required');
      verifyNever(
          () => userService.loginWithSocialKey(any(), any(), any(), any()));
      verifyNever(
          () => userService.loginWithEmailPassword(any(), any(), any()));
    });
  });
}
