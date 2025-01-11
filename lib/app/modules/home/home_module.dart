import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/home/home_page.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (_) => HomePage());
  }


}
