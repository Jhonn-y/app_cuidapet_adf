import 'package:cuidapet_api/entities/user.dart';

abstract class IUserRepo {
  Future<User> createUser(User user);
  Future<User> loginWithEmailPassword(String email, String password, bool supplierUser);
  Future<User> loginWithSocialKey(String email, String socialKey,String socialType);
  Future<void> updateUserDeviceTokenAndRefreshToken(User user);
  Future<void> updateRefreshToken(User user);
  Future<User> findByID(int id);
  Future<void> updateUrlAvatar(int id, String urlAvatar);

}