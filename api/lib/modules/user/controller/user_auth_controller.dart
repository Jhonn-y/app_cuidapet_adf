// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:cuidapet_api/application/exeptions/user_exists_exception.dart';
import 'package:cuidapet_api/application/exeptions/user_not_found_exception.dart';
import 'package:cuidapet_api/application/helpers/jwt_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/view_models/user_confirm_input_model.dart';
import 'package:cuidapet_api/modules/user/view_models/user_login_view_model.dart';
import 'package:cuidapet_api/modules/user/view_models/user_refresh_token_input_model.dart';
import 'package:cuidapet_api/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'user_auth_controller.g.dart';

@injectable
class UserAuthController {
  IUserService userService;
  ILogger log;
  UserAuthController({
    required this.userService,
    required this.log,
  });

  @Route.post('/')
  Future<Response> login(Request request) async {
    try {
      final loginViewModel = UserLoginViewModel(await request.readAsString());

      User user;

      if (!loginViewModel.socialLogin) {
        user = await userService.loginWithEmailPassword(loginViewModel.login,
            loginViewModel.password, loginViewModel.supplierUser);
      } else {
        user = await userService.loginWithSocialKey(
            loginViewModel.login,
            loginViewModel.avatar,
            loginViewModel.socialType,
            loginViewModel.socialKey);
      }

      return Response.ok(jsonEncode(
          {'access_token': JwtHelper.generateJwt(user.id!, user.supplierID)}));
    } on UserNotFoundException {
      return Response.forbidden(
          jsonEncode({'message': 'usuario ou senha invalidos!'}));
    } catch (e) {
      log.error('Erro ao fazer login', e);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Ocorreu um erro interno'}));
    }
  }

  @Route.post('/register')
  Future<Response> saveUser(Request request) async {
    try {
      final userModel = UserSaveInputModel(await request.readAsString());
      await userService.createUser(userModel);

      return Response.ok(jsonEncode({'message': 'Cadastro realizado!!'}));
    } on UserExistsException {
      return Response(400,
          body: jsonEncode({'message': 'Usuario ja cadastrado!'}));
    } on Exception catch (e) {
      log.error('Erro ao cadastrar usuario', e);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Ocorreu um erro interno'}));
    }
  }

  @Route('PATCH', '/confirm')
  Future<Response> confirmUser(Request request) async {
    final user = int.parse(request.headers['user']!);
    final supplier = int.tryParse(request.headers['supplier'] ?? '');
    final token =
        JwtHelper.generateJwt(user, supplier).replaceAll('Bearer', '');

    final inputModel = UserConfirmInputModel(
        userID: user, accessToken: token, data: await request.readAsString());

    final refreshToken = await userService.confirmLogin(inputModel);

    return Response.ok(jsonEncode(
        {'access_token': 'Bearer $token', 'refresh_token': refreshToken}));
  }

  @Route.put('/refresh/')
  Future<Response> refreshToken(Request request) async {
    try {
  final user = int.parse(request.headers['user']!);
  final supplier = int.tryParse(request.headers['supplier'] ?? '');
  final accesToken = request.headers['access_token']!;
  final model = UserRefreshTokenInputModel(
      user: user,
      supplier: supplier,
      accessToken: accesToken,
      dataRequest: await request.readAsString());
  
  final userRefreshToken = await userService.refreshToken(model);
  
  return Response.ok(jsonEncode({
    'access_token': userRefreshToken.accessToken,
    'refresh_token': userRefreshToken.refreshToken
  }));
} catch (e) {
  return Response.internalServerError();
}
  }

  Router get router => _$UserAuthControllerRouter(this);
}
