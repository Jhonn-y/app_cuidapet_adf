// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/application/database/i_database_conn.dart';
import 'package:cuidapet_api/application/exeptions/database_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/schedule.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import './i_schedule_repo.dart';

@LazySingleton(as: IScheduleRepo)
class ScheduleRepo implements IScheduleRepo {
  IDatabaseConn connection;
  ILogger log;
  ScheduleRepo({
    required this.connection,
    required this.log,
  });

  @override
  Future<void> save(Schedule schedule) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      await conn.transaction((_) async {
        final result = await conn!.query('''
            INSERT INTO 
            agendamento(data_agendamento, usuario_id, fornecedor_id, status, nome, nome_pet)
            VALUES(?,?,?,?,?,?)
            ''', [
          schedule.scheduleDate.toIso8601String(),
          schedule.userID,
          schedule.supplier.id,
          schedule.status,
          schedule.name,
          schedule.petName
        ]);

        final scheduleID = result.insertId;

        if (scheduleID != null) {
          await conn.queryMulti('''
          INSERT INTO agendamento_servicos values(?,?)''',
              schedule.services.map((s) => [s.service.id]));
        }
      });
    } on MySqlException catch (e) {
      log.error('Erro ao salvar', e);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
