import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/supplier/supplier_page.dart';

class SupplierModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (_) => SupplierPage());
  }
}
