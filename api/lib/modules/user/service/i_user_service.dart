import 'package:cuidapet_api/modules/user/view_models/user_save_input_model.dart';

abstract class IUserService {

  Future createUser(UserSaveInputModel user);

}