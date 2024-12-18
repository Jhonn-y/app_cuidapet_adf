
import 'package:cuidapet_api/application/config/database_connection_configuration.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:dotenv/dotenv.dart';
import 'package:get_it/get_it.dart';

import '../logger/logger.dart';



class ApplicationConfig {
  late DotEnv env;
  Future<void> loadConfigApplication() async {
    await _loadEnv();
    _loadDatabaseConfig();
    _configLogger();
  }
  Future<void> _loadEnv() async => env = DotEnv(includePlatformEnvironment: true)..load();
  
  void _loadDatabaseConfig() {
    final databaseConfig = DatabaseConnectionConfiguration(
        databaseName: env['DATABASE_NAME'] ?? env['databaseName']!,
        host: env['DATABASE_HOST'] ?? env['databaseHost']!,
        port: int.tryParse(env['DATABASE_PORT'] ?? env['databasePort']!)?? 0,
        user: env['DATABASE_USER'] ?? env['databaseUser']!,
        password: env['DATABASE_PASSWORD'] ?? env['databasePassword']!);
        GetIt.I.registerSingleton(databaseConfig);
  }
  
  void _configLogger() => GetIt.I.registerLazySingleton<ILogger>(()=> Logger());
}
