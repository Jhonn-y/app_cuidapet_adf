import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/auth/auth_module.dart';
import 'package:projeto_cuidapet/app/modules/auth/register/register_controller.dart';
import 'package:projeto_cuidapet/app/modules/auth/register/register_page.dart';

class RegisterModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton(RegisterController.new);
  }

  @override
  List<Module> get imports => [
        AuthModule(),
      ];

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (_) => RegisterPage());
  }
}
