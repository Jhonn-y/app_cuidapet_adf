
import 'package:cuidapet_api/application/router/i_router.dart';
import 'package:cuidapet_api/modules/user/controller/user_auth_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/shelf_router.dart';

import 'controller/user_controller.dart';


class UserRouter  implements IRouter{
  @override
  void configure(Router route) {

    final authController = GetIt.I<UserAuthController>();
    final userController = GetIt.I<UserController>();

    route.mount('/auth/', authController.router.call);
    route.mount('/user/', userController.router.call);
  
  }
  
}