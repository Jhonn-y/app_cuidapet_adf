// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/application/database/i_database_conn.dart';
import 'package:cuidapet_api/application/exeptions/database_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/dtos/supplier_near_by_me_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import './i_supplier_repo.dart';

@LazySingleton(as: ISupplierRepo)
class SupplierRepo implements ISupplierRepo {
  IDatabaseConn connetion;
  ILogger log;
  SupplierRepo({
    required this.connetion,
    required this.log,
  });

  @override
  Future<List<SupplierNearByMeDto>> findNearByPosition(
      double lat, double long, int distance) async {
    MySqlConnection? conn;
    try {
      conn = await connetion.openConnection();
      final query = '''
        SELECT f.id,f.nome,f.logo,f.categorias_fornecedor_id,
        (6371 * 
          acos(
                  cos(radians($lat)) *
                  cos(radians(ST_X(f.latlng))) *
                  cos(radians($long) - radians(ST_Y(f.latlng))) +
                  sin(radians($lat)) *
                  sin(radians(ST_X(f.latlng)))
              )) AS distancia
          FROM fornecedor f
          HAVING distancia <= $distance;       
        ''';

      final result = await conn.query(query);

      return result
          .map((sup) => SupplierNearByMeDto(
              id: sup['id'],
              name: sup['nome'],
              logo: (sup['logo'] as Blob?)?.toString(),
              distance: sup['distancia'],
              categoryID: sup['categorias_fornecedor_id']))
          .toList();
    } on MySqlException catch (e) {
      log.error('Error ao buscar fornecedores próximos', e);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
