import 'package:flutter/widgets.dart';
import 'package:projeto_cuidapet/app/core/database/sqlite_conn_factory.dart';

class SqliteAdmConnection with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    var connection = SqliteConnFactory();

    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.hidden:
      break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        connection.closeConnection();
        break;
      
    }
  }
}
