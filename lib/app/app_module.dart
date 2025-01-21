import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/auth/auth_module.dart';
import 'package:projeto_cuidapet/app/modules/core_module/core_module.dart';
import 'package:projeto_cuidapet/app/modules/home/home_module.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void routes(RouteManager r) {
    r.module('/auth/', module: AuthModule());
    r.module('/home/', module: HomeModule());
  }
}
