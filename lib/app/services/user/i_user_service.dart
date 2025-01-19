import 'package:projeto_cuidapet/app/model/social_login_type.dart';

abstract class IUserService {
  Future<void> register(String email, String password);
  Future<void> login(String email, String password);
  Future<void> socialLogin(SocialLoginType loginType);

}