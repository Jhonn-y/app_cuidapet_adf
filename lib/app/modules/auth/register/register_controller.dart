import 'package:mobx/mobx.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';
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


  void register({required String email, required String password}){

  }

  
}
