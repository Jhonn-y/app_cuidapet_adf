import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/core/rest_client/dio/dio_rest_client.dart';
import 'package:projeto_cuidapet/app/core/rest_client/rest_client.dart';
import 'package:projeto_cuidapet/app/modules/core_module/auth/auth_store.dart';

class CoreModule extends Module {
  
  @override
  void exportedBinds(Injector i) {
    i.addLazySingleton(AuthStore.new);
    i.addLazySingleton<RestClient>(DioRestClient.new);
  }
}
