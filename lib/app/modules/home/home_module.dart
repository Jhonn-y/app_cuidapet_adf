import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/core_module/core_module.dart';
import 'package:projeto_cuidapet/app/modules/core_module/supplier/supplier_core_module.dart';
import 'package:projeto_cuidapet/app/modules/home/home_controller.dart';
import 'package:projeto_cuidapet/app/modules/home/home_page.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton(HomeController.new);
  }

  @override
  List<Module> get imports => [
        CoreModule(),
        SupplierCoreModule(),
      ];

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (_) => HomePage());
  }
}
