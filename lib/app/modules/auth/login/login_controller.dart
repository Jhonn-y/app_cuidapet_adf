import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:projeto_cuidapet/app/core/exceptions/failure.dart';
import 'package:projeto_cuidapet/app/core/exceptions/user_not_exists_exception.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/loader.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/messages.dart';
import 'package:projeto_cuidapet/app/model/social_login_type.dart';
import 'package:projeto_cuidapet/app/services/user/i_user_service.dart';
part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final IUserService _userService;
  final AppLogger _log;

  _LoginControllerBase(
      {required IUserService userService, required AppLogger log})
      : _userService = userService,
        _log = log;

  Future<void> login({required String email, required String password}) async {
    try {
      Loader.show();
      await _userService.login(email, password);
      Loader.hide();
      Modular.to.navigate('/auth/');
    } on UserNotExistsException catch (e) {
      _log.error('Usuario não cadastrado', e);
      Loader.hide();
      Messages.alert('Usuario não cadastrado');
    } on Failure catch (e) {
      final errorMessage = e.message ?? 'Erro ao fazer login';
      _log.error(errorMessage, e);
      Loader.hide();
      Messages.alert(errorMessage);
    }
  }

  Future<void> socialLogin(SocialLoginType socialLoginType) async {
    try {
      Loader.show();
      await _userService.socialLogin(socialLoginType);
      Loader.hide();
      Modular.to.navigate('/auth/');
    } on Failure catch (e) {
      Loader.hide();
      _log.error('Erro ao realizar login', e);
      Messages.alert(e.message ?? 'Erro ao realizar login');
    }
  }
}
