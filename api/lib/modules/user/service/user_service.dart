// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cuidapet_api/modules/user/data/i_user_repo.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';

import '../../../entities/user.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  IUserRepo userRepo;
  UserService({
    required this.userRepo,
  });

  @override
  Future createUser(UserSaveInputModel user) {
    final userEntity = User(
      email: user.email,
      password: user.password,
      registerType: 'App',
      supplierID: user.supplierID,
    );

    return userRepo.createUser(userEntity);
  }
  
  @override
  Future loginWithEmailPassword(String email, String password, bool supplierUser) 
  => userRepo.loginWithEmailPassword(email, password, supplierUser);
}
