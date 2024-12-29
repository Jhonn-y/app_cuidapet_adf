import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/view_models/refresh_token_view_model.dart';
import 'package:cuidapet_api/modules/user/view_models/user_confirm_input_model.dart';
import 'package:cuidapet_api/modules/user/view_models/user_refresh_token_input_model.dart';
import 'package:cuidapet_api/modules/user/view_models/user_save_input_model.dart';

abstract class IUserService {

  Future createUser(UserSaveInputModel user);
  Future loginWithEmailPassword(String email, String password, bool supplierUser);
  Future loginWithSocialKey(String email,String avatar, String socialKey,String socialType);
  Future<String> confirmLogin(UserConfirmInputModel inputModel);
  Future<RefreshTokenViewModel> refreshToken(UserRefreshTokenInputModel model);
  Future<User> findByID(int id);

}