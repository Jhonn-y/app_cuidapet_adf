import 'package:cuidapet_api/entities/user.dart';

abstract class IUserRepo {
  Future createUser(User user);
  Future loginWithEmailPassword(String email, String password, bool supplierUser);
  Future loginWithSocialKey(String email, String socialKey,String socialType);
  Future updateUserDeviceTokenAndRefreshToken(User user);

}