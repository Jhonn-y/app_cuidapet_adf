
import 'package:cuidapet_api/application/helpers/request_mapping.dart';

class UserSaveInputModel extends RequestMapping{
  late String email;
  late String password;
  int? supplierID;

  UserSaveInputModel(super.data);
  
  @override
  void map() {
    email = data['email'];
    password = data['password'];
  }  
  
  
}