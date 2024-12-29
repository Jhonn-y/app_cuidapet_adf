// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/application/database/i_database_conn.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/categories.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import './i_categories_repo.dart';

@LazySingleton(as: ICategoriesRepo)
class CategoriesRepo implements ICategoriesRepo {
  IDatabaseConn connection;
  ILogger log;
  CategoriesRepo({
    required this.connection,
    required this.log,
  });

  @override
  Future<List<Categories>> find() async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('select * from categorias_fornecedor');

      if (result.isNotEmpty) {
        return result
            .map((data) => Categories(
                id: data['id'],
                name: data['nome_categoria'],
                type: data['tipo_categoria']))
            .toList();
      }
      
      return [];
    } on MySqlException catch (e) {
      log.error('Erro ao achar categorias', e);
      return [];
    } finally {
      await conn?.close();
    }
  }
}
