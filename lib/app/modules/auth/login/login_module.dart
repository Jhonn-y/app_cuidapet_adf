import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/auth/login/login_page.dart';

class LoginModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (_) => LoginPage());
  }
}
