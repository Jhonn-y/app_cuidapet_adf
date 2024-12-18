import 'package:mysql1/mysql1.dart';

abstract class IDatabaseConn {

  Future<MySqlConnection> openConnection();

}