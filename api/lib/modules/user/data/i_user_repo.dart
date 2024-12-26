import 'package:cuidapet_api/entities/user.dart';

abstract class IUserRepo {
  Future createUser(User user);

}