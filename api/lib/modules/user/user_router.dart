
import 'package:cuidapet_api/application/router/i_router.dart';
import 'package:cuidapet_api/modules/user/controller/user_auth_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/shelf_router.dart';


class UserRouter  implements IRouter{

  final authController = GetIt.I<UserAuthController>();

  @override
  void configure(Router route) {
    route.mount('/auth/', authController.router.call);
  
  }
  
}