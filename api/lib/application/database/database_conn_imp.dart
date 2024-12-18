import 'package:cuidapet_api/application/config/database_connection_configuration.dart';
import 'package:cuidapet_api/application/database/i_database_conn.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';


@LazySingleton(as: IDatabaseConn)
class DatabaseConnImp implements IDatabaseConn {
  final DatabaseConnectionConfiguration _configuration;

  DatabaseConnImp({required DatabaseConnectionConfiguration configuration})
      : _configuration = configuration;

  @override
  Future<MySqlConnection> openConnection() {
    return MySqlConnection.connect(ConnectionSettings(
      host: _configuration.host,
      port: _configuration.port,
      user: _configuration.user,
      password: _configuration.password,
      db: _configuration.databaseName,
    ));
  }
}
