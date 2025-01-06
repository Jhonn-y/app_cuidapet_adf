// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/application/database/i_database_conn.dart';
import 'package:cuidapet_api/application/exeptions/database_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import './i_chat_repo.dart';

@LazySingleton(as: IChatRepo)
class ChatRepo implements IChatRepo {
  IDatabaseConn connection;
  ILogger log;
  ChatRepo({
    required this.connection,
    required this.log,
  });

  @override
  Future<int> startChat(int scheduleID) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final result = await conn.query('''
        INSERT INTO chats (agendamento_id,status,data_criacao) VALUES (?,?,?)
        ''', [
        scheduleID,
        'A',
        DateTime.now().toIso8601String(),
      ]);

      return result.insertId!;
    } on MySqlException catch (e) {
      log.error('Erro ao iniciar chat', e);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
