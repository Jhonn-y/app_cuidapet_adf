import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/auth/home/auth_home_page.dart';

class AuthModule extends Module {
  @override
  void binds(Injector i) {
    
  }

  @override
  void routes(RouteManager r) {

    r.child(Modular.initialRoute, child: (_) => AuthHomePage());
  }
}
