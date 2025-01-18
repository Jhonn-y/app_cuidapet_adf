import 'package:projeto_cuidapet/app/model/confirm_login_model.dart';

abstract class IUserRepo {
  Future<void> register(String email, String password);
  Future<String> login(String email, String password);
  Future<ConfirmLoginModel> confirmLogin();
}
