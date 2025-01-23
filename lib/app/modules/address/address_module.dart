import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/address/address_controller.dart';
import 'package:projeto_cuidapet/app/modules/address/address_detail/address_detail_module.dart';
import 'package:projeto_cuidapet/app/modules/address/address_page.dart';
import 'package:projeto_cuidapet/app/modules/address/widgets/address_search_widget/address_search_controller.dart';
import 'package:projeto_cuidapet/app/modules/core_module/core_module.dart';

class AddressModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton(AddressController.new);
    i.addLazySingleton(AddressSearchController.new);
  }

  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (_) => AddressPage());
    r.module('/detail/', module: AddressDetailModule());

  }
  
  
}
