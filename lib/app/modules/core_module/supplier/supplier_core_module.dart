import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/core_module/core_module.dart';
import 'package:projeto_cuidapet/app/repo/supplier/i_supplier_repo.dart';
import 'package:projeto_cuidapet/app/repo/supplier/supplier_repo.dart';
import 'package:projeto_cuidapet/app/services/supplier/i_supplier_service.dart';
import 'package:projeto_cuidapet/app/services/supplier/supplier_service.dart';

class SupplierCoreModule extends Module {

  @override
  void exportedBinds(Injector i) {
    i.addLazySingleton<ISupplierRepo>(SupplierRepo.new);
    i.addLazySingleton<ISupplierService>(SupplierService.new);
  }

  @override
  List<Module> get imports => [
        CoreModule(),
      ];
}
