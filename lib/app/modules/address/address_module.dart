import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/address/address_page.dart';

class AddressModule extends Module {
  @override
  void binds(Injector i) {
    // TODO: implement binds
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (_) => AddressPage());
  }
}
