// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/supplier.dart';
import 'package:cuidapet_api/modules/supplier/service/i_supplier_service.dart';
import 'package:cuidapet_api/modules/supplier/view_models/create_supplier_user_view_model.dart';
import 'package:cuidapet_api/modules/supplier/view_models/supplier_update_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'supplier_controller.g.dart';

@injectable
class SupplierController {
  ISupplierService service;
  ILogger log;
  SupplierController({
    required this.service,
    required this.log,
  });

  @Route.get('/')
  Future<Response> findNearByMe(Request request) async {
    try {
      final lat = double.tryParse(request.url.queryParameters['lat'] ?? '');
      final long = double.tryParse(request.url.queryParameters['long'] ?? '');

      if (lat == null || long == null) {
        return Response(400,
            body: jsonEncode({'message': 'Latitude e Longitude obrigatorios'}));
      }

      final suppliers = await service.findNearByHere(lat, long);
      final result = suppliers
          .map((sup) => {
                'id': sup.id,
                'name': sup.name,
                'logo': sup.logo,
                'distance': sup.distance,
                'category': sup.categoryID,
              })
          .toList();

      return Response.ok(jsonEncode(result));
    } catch (e) {
      log.error('Error ao buscar por fornecedores proximos: $e');
      return Response.internalServerError();
    }
  }

  @Route.get('/<id|[0-9]+>')
  Future<Response> findByID(Request request, String id) async {
    final supplier = await service.findByID(int.parse(id));

    if (supplier == null) {
      return Response.ok(jsonEncode({}));
    }

    return Response.ok(_supplierMapper(supplier));
  }

  @Route.get('/<supID|[0-9]+>/services')
  Future<Response> findServicesBySupplierID(
      Request request, String supID) async {
    try {
      final supplierServices =
          await service.findServicesBySupplierID(int.parse(supID));
      final result = supplierServices
          .map((e) => {
                'id': e.id,
                'supplier_id': e.supplierID,
                'name': e.name,
                'price': e.price,
              })
          .toList();

      return Response.ok(jsonEncode(result));
    } on MySqlException catch (e) {
      log.error('Error ao buscar servicos do fornecedor: $e');
      return Response.internalServerError();
    }
  }

  @Route.get('/user')
  Future<Response> checkUserExists(Request request) async {
    final email = request.url.queryParameters['email'];
    if (email == null) {
      return Response.badRequest(
          body: jsonEncode({'message': 'Email obrigatorio'}));
    }
    final isEmailExists = await service.checkUserExists(email);
    return isEmailExists ? Response(200) : Response(204);
  }

  @Route.post('/user')
  Future<Response> saveSupplierUser(Request request) async {
    try {
      final model = CreateSupplierUserViewModel(await request.readAsString());
      await service.createUserSupplier(model);
      return Response.ok(jsonEncode({}));
    } catch (e) {
      log.error('Error ao salvar usuario do fornecedor: $e');
      return Response.internalServerError();
    }
  }

  @Route.put('/')
  Future<Response> update(Request request) async {
    try {
      final supplier = int.parse(request.headers['supplier'] ?? '');

      if (supplier == '') {
        return Response.badRequest(
            body: jsonEncode({'message': 'Fornecedor não pode ser nulo'}));
      }

      final model = SupplierUpdateInputModel(
          supplierID: supplier, dataRequest: await request.readAsString());
      final supplierResponse = await service.update(model);

      return Response.ok(jsonEncode(_supplierMapper(supplierResponse)));
    } catch (e) {
      log.error('Error ao atualizar fornecedor',e);
      return Response.internalServerError();
    }
  }

  String _supplierMapper(Supplier supplier) {
    return jsonEncode({
      'id': supplier.id,
      'name': supplier.name,
      'logo': supplier.logo,
      'address': supplier.address,
      'phone': supplier.phone,
      'latitude': supplier.lat,
      'longitude': supplier.lng,
      'category': {
        'id': supplier.category?.id,
        'name': supplier.category?.name,
        'type': supplier.category?.type
      }
    });
  }

  Router get router => _$SupplierControllerRouter(this);
}
