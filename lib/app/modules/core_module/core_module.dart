import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/core_module/auth/auth_store.dart';

class CoreModule extends Module {
  
  @override
  void exportedBinds(Injector i) {
    i.addLazySingleton(AuthStore.new);
  }
}
