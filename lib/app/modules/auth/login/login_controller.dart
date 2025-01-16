import 'package:mobx/mobx.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/loader.dart';
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
    Loader.show();
    Future.delayed(
      Duration(seconds: 1),
    );
    Loader.hide();
  }
}
