import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/auth/auth_module.dart';
import 'package:projeto_cuidapet/app/modules/auth/login/login_controller.dart';
import 'package:projeto_cuidapet/app/modules/auth/login/login_page.dart';

class LoginModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton(LoginController.new);
  }

  @override
  List<Module> get imports => [
        AuthModule(),
      ];
      
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (_) => LoginPage());
  }
}
