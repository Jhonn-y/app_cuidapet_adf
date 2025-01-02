// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/supplier.dart';
import 'package:cuidapet_api/modules/supplier/service/i_supplier_service.dart';
import 'package:injectable/injectable.dart';
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
