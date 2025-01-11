import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/auth/home/auth_home_page.dart';
import 'package:projeto_cuidapet/app/modules/auth/login/login_module.dart';
import 'package:projeto_cuidapet/app/modules/core_module/auth/auth_store.dart';
import 'package:projeto_cuidapet/app/modules/core_module/core_module.dart';

class AuthModule extends Module {
  @override
  void binds(Injector i) {}


  @override
  List<Module> get imports => [
    CoreModule(),
  ];


  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute,
        child: (_) => AuthHomePage(
              authStore: Modular.get<AuthStore>(),
            ));
    r.module('/login/', module: LoginModule());
  }
}
