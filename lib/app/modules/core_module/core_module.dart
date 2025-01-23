import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/core/database/sqlite_conn_factory.dart';
import 'package:projeto_cuidapet/app/core/local_storage/flutter_secured_storage/flutter_secure_storage_local_storage_impl.dart';
import 'package:projeto_cuidapet/app/core/local_storage/local_storage.dart';
import 'package:projeto_cuidapet/app/core/local_storage/shared_preferences/shared_preferences_local_storage_impl.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger_impl.dart';
import 'package:projeto_cuidapet/app/core/rest_client/dio/dio_rest_client.dart';
import 'package:projeto_cuidapet/app/core/rest_client/rest_client.dart';
import 'package:projeto_cuidapet/app/modules/core_module/auth/auth_store.dart';
import 'package:projeto_cuidapet/app/repo/address/address_repo.dart';
import 'package:projeto_cuidapet/app/repo/address/i_address_repo.dart';
import 'package:projeto_cuidapet/app/services/address/address_service.dart';
import 'package:projeto_cuidapet/app/services/address/i_address_service.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addLazySingleton(SqliteConnFactory.new);
    i.addLazySingleton<AppLogger>(AppLoggerImpl.new);
    i.addLazySingleton<LocalStorage>(SharedPreferencesLocalStorageImpl.new);
    i.addLazySingleton<LocalSecureStorage>(
        FlutterSecureStorageLocalStorageImpl.new);
    i.addLazySingleton(AuthStore.new);
    i.addLazySingleton<RestClient>(DioRestClient.new);
    i.addLazySingleton<IAddressRepo>(AddressRepo.new);
    i.addLazySingleton<IAddressService>(AddressService.new);
  }
}
