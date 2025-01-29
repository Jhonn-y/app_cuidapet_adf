import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/address/address_module.dart';
import 'package:projeto_cuidapet/app/modules/auth/auth_module.dart';
import 'package:projeto_cuidapet/app/modules/core_module/core_module.dart';
import 'package:projeto_cuidapet/app/modules/home/home_module.dart';
import 'package:projeto_cuidapet/app/modules/schedules/schedules_module.dart';
import 'package:projeto_cuidapet/app/modules/supplier/supplier_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void routes(RouteManager r) {
    r.module('/auth/', module: AuthModule());
    r.module('/home/', module: HomeModule());
    r.module('/address/', module: AddressModule());
    r.module('/supplier/', module: SupplierModule());
    r.module('/schedules/', module: SchedulesModule());
  }
}
