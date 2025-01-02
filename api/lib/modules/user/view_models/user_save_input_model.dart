
import 'package:cuidapet_api/application/helpers/request_mapping.dart';

class UserSaveInputModel extends RequestMapping{
  late String email;
  late String password;
  int? supplierID;

  UserSaveInputModel({required this.email,required this.password,this.supplierID}) : super.empty();


  UserSaveInputModel.requestMapping(super.dataRequest);
  
  @override
  void map() {
    email = data['email'];
    password = data['password'];
  }  
  
  
}