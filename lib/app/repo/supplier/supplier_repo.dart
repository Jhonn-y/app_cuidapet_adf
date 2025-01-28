import 'package:projeto_cuidapet/app/core/exceptions/failure.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';
import 'package:projeto_cuidapet/app/core/rest_client/rest_client.dart';
import 'package:projeto_cuidapet/app/core/rest_client/rest_client_exception.dart';
import 'package:projeto_cuidapet/app/entities/address_entity.dart';
import 'package:projeto_cuidapet/app/model/supplier_category_model.dart';
import 'package:projeto_cuidapet/app/model/supplier_near_by_me_model.dart';

import 'i_supplier_repo.dart';

class SupplierRepo implements ISupplierRepo {
  final RestClient _restClient;
  final AppLogger _log;

  SupplierRepo({required RestClient restClient, required AppLogger log})
      : _restClient = restClient,
        _log = log;

  @override
  Future<List<SupplierCategoryModel>> getCategories() async {
    try {
      final result = await _restClient.auth().get('/categories/');

      return result.data
          ?.map<SupplierCategoryModel>(
            (categoryResponse) =>
                SupplierCategoryModel.fromMap(categoryResponse),
          )
          .toList();
    } on RestClientException catch (e) {
      _log.error('Erro ao buscar categorias', e);
      throw Failure(message: 'Erro ao buscar categorias');
    }
  }

  @override
  Future<List<SupplierNearByMeModel>> findNearBy(
      AddressEntity addressEntity) async {
    try {
      final result =
          await _restClient.auth().get('/suppliers/', queryParameters: {
        'lat': addressEntity.lat,
        'lng': addressEntity.lng,
      });

      return result.data
          ?.map<SupplierNearByMeModel>(
            (supplierResponse) =>
                SupplierNearByMeModel.fromMap(supplierResponse),
          )
          .toList();
    } on RestClientException catch (e) {
      _log.error('Erro ao buscar pontos de atendimento próximos', e);
      throw Failure(message: 'Erro ao buscar pontos de atendimento próximos');
    }
  }
}
