// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/application/database/i_database_conn.dart';
import 'package:cuidapet_api/application/exeptions/database_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/chat.dart';
import 'package:cuidapet_api/entities/device_token.dart';
import 'package:cuidapet_api/entities/supplier.dart';
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

  @override
  Future<Chat?> findChatByID(int chatID) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final query = '''
        SELECT
          c.id,
          c.data_criacao,
          c.status,
          a.nome AS agendamento_nome,
          a.nome_pet AS agendamento_nome_pet,
          a.fornecedor_id,
          a.usuario_id,
          f.nome AS fornec_nome,
          f.logo,
          u.android_token AS user_android_token,
          u.ios_token AS user_ios_token
          uf.android_token AS fornec_android_token,
          uf.ios_token AS fornec_ios_token
        FROM chats as c
        INNER JOIN agendamento a on a.id = c.agendamento_id
        INNER JOIN fornecedor f on f.id = a.fornecedor_id
        INNER JOIN usuario u ON u.id = a.usuario_id
        INNER JOIN usuario uf ON uf.fornecedor_id = f.id
      WHERE c.id = ?
      ''';

      final result = await conn.query(query, [chatID]);

      if (result.isNotEmpty) {
        final resultMsql = result.first;
        return Chat(
            id: resultMsql['id'],
            status: resultMsql['status'],
            name: resultMsql['agendamento_nome'],
            petName: resultMsql['agendamento_nome_pet'],
            supplier: Supplier(
              id: resultMsql['fornecedor_id'],
              name: resultMsql['fornec_nome'],
            ),
            user: resultMsql['usuario_id'],
            userDeviceToken: DeviceToken(
              android: (resultMsql['user_android_token'] as Blob?)?.toString(),
              ios: (resultMsql['user_ios_token'] as Blob?)?.toString(),
            ),
            supplierDeviceToken: DeviceToken(
              android:
                  (resultMsql['fornec_android_token'] as Blob?)?.toString(),
              ios: (resultMsql['fornec_ios_token'] as Blob?)?.toString(),
            ));
      }
      return null;
    } on MySqlException catch (e) {
      log.error('Erro ao buscar dados do chat', e);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<List<Chat>> getChatsByUser(int user) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final query = '''
        SELECT 
          c.id,c.data_criacao,c.status,
          a.nome,a.nome_pet,a.fornecedor_id,a.usuario_id,
          f.nome AS fornec_nome,f.logo,
        FROM chats as c
        INNER JOIN agendamento a on a.id = c.agendamento_id
        INNER JOIN fornecedor f on f.id = a.fornecedor_id
        WHERE 
          a.usuario_id = ?
        AND
          c.status = 'A'
        ORDER BY 
          c.data_criacao
        ''';

      final result = await conn.query(query,[user]);

      return result
          .map((c) => Chat(
              id: c['id'],
              user: c['usuario_id'],
              supplier: Supplier(
                id: c['fornecedor_id'],
                name: c['fornec_nome'],
                logo: (c['logo'] as Blob?)?.toString(),
              ),
              name: c['nome'],
              petName: c['nome_pet'],
              status: c['status']))
          .toList();
    } on MySqlException catch (e) {
      log.error('Erro ao buscar chats', e);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
