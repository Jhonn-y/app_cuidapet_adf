

import 'package:cuidapet_api/application/helpers/request_mapping.dart';

class UserLoginViewModel extends RequestMapping {

  late String login;
  late String password;
  late bool socialLogin;
  late bool supplierUser;

  UserLoginViewModel(super.dataRequest);

  @override
  void map() {
    login = data['login'];
    password = data['password'];
    socialLogin = data['social_login'];
    supplierUser = data['supplier_user'];
  
  }
  
  
}