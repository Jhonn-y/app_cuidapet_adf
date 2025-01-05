// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/application/database/i_database_conn.dart';
import 'package:cuidapet_api/application/exeptions/database_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/schedule.dart';
import 'package:cuidapet_api/entities/schedule_supplier_entity.dart';
import 'package:cuidapet_api/entities/supplier.dart';
import 'package:cuidapet_api/entities/supplier_service.dart';
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

  @override
  Future<void> changeStatus(String status, int scheduleID) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      await conn.query('''
        UPDATE agendamento
        SET status = ?
        WHERE id = ?
        ''', [status, scheduleID]);
    } on MySqlException catch (e) {
      log.error('Erro ao alterar status', e);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<List<Schedule>> findAllschedulesByUser(int userID) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final query = '''
        SELECT 
          a.id as agen_id,
          a.data_agendamento,
          a.status,
          a.nome,
          a.nome_pet,
          f.nome as fornec_nome,
          f.logo
        FROM agendamento as a
        INNER JOIN fornecedor f ON f.id = a.fornecedor_id
        WHERE a.usuario_id = ?
        ''';

      final result = await conn.query(query, [userID]);

      final scheduleResult = result
          .map((s) async => Schedule(
              id: s['id'],
              scheduleDate: s['data_agendamento'],
              status: s['status'],
              name: s['nome'],
              petName: s['nome_pet'],
              userID: userID,
              supplier: Supplier(
                id: s['fornec_id'],
                name: s['fornec_nome'],
                logo: (s['logo'] as Blob?)?.toString(),
              ),
              services: await findAllServicesBySchedule(s['id'])))
          .toList();

      return Future.wait(scheduleResult);
    } on MySqlException catch (e) {
      log.error('Erro ao buscar agendamentos do usuario', e);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }


  @override
  Future<List<Schedule>> findAllschedulesByUserSupplier(int userID) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final query = '''
        SELECT 
          a.id as agen_id,
          a.data_agendamento,
          a.status,
          a.nome,
          a.nome_pet,
          f.nome as fornec_nome,
          f.logo
        FROM agendamento as a
        INNER JOIN fornecedor f ON f.id = a.fornecedor_id
        INNER JOIN usuario u on u.fornecedor_id = f.id
        WHERE u.id = ?
        ''';

      final result = await conn.query(query, [userID]);

      final scheduleResult = result
          .map((s) async => Schedule(
              id: s['id'],
              scheduleDate: s['data_agendamento'],
              status: s['status'],
              name: s['nome'],
              petName: s['nome_pet'],
              userID: userID,
              supplier: Supplier(
                id: s['fornec_id'],
                name: s['fornec_nome'],
                logo: (s['logo'] as Blob?)?.toString(),
              ),
              services: await findAllServicesBySchedule(s['id'])))
          .toList();

      return Future.wait(scheduleResult);
    } on MySqlException catch (e) {
      log.error('Erro ao buscar agendamentos do usuario', e);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  Future<List<ScheduleSupplierEntity>> findAllServicesBySchedule(int scheduleID) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final result = await conn.query('''
        SELECT
          fs.id,fs.nome_servico, fs.valor_servico,fs.fornecedor_id
        FROM agendamento_servicos as agend_servc
        INNER JOIN fornecedor_servicos fs on fs.id = agend_servc.fornecedor_servicos_id
        WHERE agend_serv.agendamento_id = ?
        ORDER BY a.data_agendamento 
        ''', [scheduleID]);

      return result
          .map((s) => ScheduleSupplierEntity(
              service: SupplierService(
                  id: s['id'],
                  name: s['nome_servico'],
                  price: s['valor_servico'],
                  supplierID: s['fornecedor_id'])))
          .toList();
    } on MySqlException catch (e) {
      log.error('Erro ao buscar servicos de um agendamento', e);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
