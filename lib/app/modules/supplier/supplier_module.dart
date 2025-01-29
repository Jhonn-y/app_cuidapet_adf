import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/core_module/core_module.dart';
import 'package:projeto_cuidapet/app/modules/core_module/supplier/supplier_core_module.dart';
import 'package:projeto_cuidapet/app/modules/supplier/supplier_controller.dart';
import 'package:projeto_cuidapet/app/modules/supplier/supplier_page.dart';

class SupplierModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton(SupplierController.new);
  }

  @override
  List<Module> get imports => [
        CoreModule(),
        SupplierCoreModule(),
      ];
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (_) => SupplierPage(supplierID: 1,));
  }
}
