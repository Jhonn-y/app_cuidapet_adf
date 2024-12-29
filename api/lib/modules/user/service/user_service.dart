// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cuidapet_api/application/exeptions/service_exception.dart';
import 'package:cuidapet_api/application/exeptions/user_not_found_exception.dart';
import 'package:cuidapet_api/application/helpers/jwt_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/user/data/i_user_repo.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/view_models/refresh_token_view_model.dart';
import 'package:cuidapet_api/modules/user/view_models/user_confirm_input_model.dart';
import 'package:cuidapet_api/modules/user/view_models/user_refresh_token_input_model.dart';
import 'package:cuidapet_api/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../../../entities/user.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  IUserRepo userRepo;
  ILogger log;
  UserService({
    required this.log,
    required this.userRepo,
  });

  @override
  Future createUser(UserSaveInputModel user) {
    final userEntity = User(
      email: user.email,
      password: user.password,
      registerType: 'App',
      supplierID: user.supplierID,
    );

    return userRepo.createUser(userEntity);
  }

  @override
  Future loginWithEmailPassword(
          String email, String password, bool supplierUser) =>
      userRepo.loginWithEmailPassword(email, password, supplierUser);

  @override
  Future loginWithSocialKey(
      String email, String avatar, String socialKey, String socialType) async {
    try {
      return await userRepo.loginWithSocialKey(email, socialKey, socialType);
    } on UserNotFoundException catch (e) {
      log.error('Usuario nao encontrado, cadastrando novo usuario');
      final user = User(
        email: email,
        password: DateTime.now().toString(),
        registerType: socialType,
        imageAvatar: avatar,
        socialKey: socialKey,
      );
      return await userRepo.createUser(user);
    }
  }

  @override
  Future<String> confirmLogin(UserConfirmInputModel inputModel) async {
    final refreshToken = JwtHelper.refreshToken(inputModel.accessToken);
    final user = User(
      id: inputModel.userID,
      refreshToken: refreshToken,
      iosToken: inputModel.iosDeviceToken,
      androidToken: inputModel.androidDeviceToken
    );

    await userRepo.updateUserDeviceTokenAndRefreshToken(user);
    return refreshToken;
  }

  @override
  Future<RefreshTokenViewModel> refreshToken(UserRefreshTokenInputModel model) async {
    _validateRefreshToken(model);

    final newAccessToken = JwtHelper.generateJwt(model.user, model.supplier);
    final newRefreshToken = JwtHelper.refreshToken(newAccessToken.replaceAll('Bearer', ' '));

    final user = User(
      id:model.user,
      refreshToken: newRefreshToken
    );

    await userRepo.updateRefreshToken(user);
    return RefreshTokenViewModel(accessToken: newAccessToken, refreshToken: newRefreshToken);
  }
  
  void _validateRefreshToken(UserRefreshTokenInputModel model) {
    try {
  final refreshToken = model.refreshToken.split('');
  
  if(refreshToken.length != 2 || refreshToken.first != 'Bearer'){
    log.error('Refresh token invalido');
    throw ServiceException();
  }
  
  final refreshTokenClaim = JwtHelper.getClaims(refreshToken.last);
  refreshTokenClaim.validate(issuer: model.accessToken);
} on ServiceException catch (e) {
  rethrow;
} on JwtException{
  log.error("Refresh token invalido");
  throw ServiceException();
}catch (e){
  throw ServiceException();
}
  }
  
  @override
  Future<User> findByID(int id) => userRepo.findByID(id);
  
  
}
