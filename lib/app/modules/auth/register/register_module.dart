import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/auth/register/register_page.dart';

class RegisterModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (_) => RegisterPage());
  }
}
