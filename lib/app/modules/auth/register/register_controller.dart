import 'package:mobx/mobx.dart';
import 'package:projeto_cuidapet/app/core/exceptions/user_exists_exception.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/loader.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/messages.dart';
import 'package:projeto_cuidapet/app/services/user/i_user_service.dart';
part 'register_controller.g.dart';

class RegisterController = _RegisterControllerBase with _$RegisterController;

abstract class _RegisterControllerBase with Store {
  final IUserService _userService;
  final AppLogger _log;

  _RegisterControllerBase(
      {required AppLogger log, required IUserService userService})
      : _userService = userService,
        _log = log;

  Future<void> register(
      {required String email, required String password}) async {
    try {
      Loader.show();
      await _userService.register(email, password);
      Messages.info(
          'Enviamos um email de confirmação, por favor olhe sua caixa de email');
      Loader.hide();
    } on UserExistsException catch (e) {
      Loader.hide();
      Messages.alert('Email ja utilizado, por favor tente outro email!');
    } catch (e) {
      _log.error('Error ao registrar: $e');
      Loader.hide();
      Messages.alert('Ocorreu um erro ao registrar, tente novamente!');
    }
  }
}
