import 'package:cuidapet_api/modules/user/view_models/user_save_input_model.dart';

abstract class IUserService {

  Future createUser(UserSaveInputModel user);
  Future loginWithEmailPassword(String email, String password, bool supplierUser);
  Future loginWithSocialKey(String email,String avatar, String socialKey,String socialType);

}