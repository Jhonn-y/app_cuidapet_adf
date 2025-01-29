import 'package:mobx/mobx.dart';
import 'package:projeto_cuidapet/app/core/life_cycle/controller_life_cycle.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/loader.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/messages.dart';
import 'package:projeto_cuidapet/app/model/supplier_model.dart';
import 'package:projeto_cuidapet/app/model/supplier_service_model.dart';
import 'package:projeto_cuidapet/app/services/supplier/i_supplier_service.dart';
part 'supplier_controller.g.dart';

class SupplierController = SupplierControllerBase with _$SupplierController;

abstract class SupplierControllerBase with Store, ControllerLifeCycle {
  final ISupplierService _supplierService;
  final AppLogger _log;

  int _supplierID = 0;

  @readonly
  SupplierModel? _supplierModel;

  @readonly
  var _supplierServiceModel = <SupplierServiceModel>[];

  SupplierControllerBase(
      {required ISupplierService supplierService, required AppLogger log})
      : _supplierService = supplierService,
        _log = log;

  @override
  onInit([Map<String, dynamic>? params]) {
    _supplierID = params?['supplierId'] ?? 0;
  }

  @override
  onReady() async {
    try {
  Loader.show();
  await Future.wait([
    _findSuppliersById(),
    _findSuppliersServices()
  ]);
} finally {
  Loader.hide();
}
  }

  @action
  Future<void> _findSuppliersById() async {
    try {
      _supplierModel = await _supplierService.findById(_supplierID);
    } catch (e) {
      _log.error('Erro ao buscar dados do fornecedor', e);
      Messages.alert('Erro ao buscar dados do fornecedor');
    }
  }

  @action
  Future<void> _findSuppliersServices() async {
    try {
      _supplierServiceModel = await _supplierService.findServices(_supplierID);
    } catch (e) {
      _log.error('Erro ao buscar dados dos serviços do fornecedor', e);
      Messages.alert('Erro ao buscar dados dos serviços do fornecedor');
    }
  }
}
