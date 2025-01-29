import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:projeto_cuidapet/app/core/life_cycle/controller_life_cycle.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/loader.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/messages.dart';
import 'package:projeto_cuidapet/app/model/supplier_model.dart';
import 'package:projeto_cuidapet/app/model/supplier_service_model.dart';
import 'package:projeto_cuidapet/app/modules/schedules/model/schedules_view_model.dart';
import 'package:projeto_cuidapet/app/services/supplier/i_supplier_service.dart';
import 'package:url_launcher/url_launcher_string.dart';
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

  @readonly
  var _servicesSupplierSelected = <SupplierServiceModel>[].asObservable();

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
      await Future.wait([_findSuppliersById(), _findSuppliersServices()]);
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

  @action
  void addOrRemoveService(SupplierServiceModel model) {
    if (_servicesSupplierSelected.contains(model)) {
      _servicesSupplierSelected.remove(model);
    } else {
      _servicesSupplierSelected.add(model);
    }
  }

  bool isServiceSelected(SupplierServiceModel model) =>
      _servicesSupplierSelected.contains(model);

  int get totalServicesSelected => _supplierServiceModel.length;

  Future<void> goToPhoneOrCopyPhoneToClipart() async {
    final phoneUrl = 'tel:${_supplierModel?.phone}';

    if (await canLaunchUrlString(phoneUrl)) {
      await launchUrlString(phoneUrl);
    } else {
      await Clipboard.setData(ClipboardData(text: _supplierModel?.phone ?? ''));
      Messages.info('Telefone copiado!');
    }
  }

  Future<void> goToGeoOrCopyPhoneToClipart() async {
    final geoUrl = 'geo:${_supplierModel?.lat}, ${_supplierModel?.lng}';

    if (await canLaunchUrlString(geoUrl)) {
      await launchUrlString(geoUrl);
    } else {
      await Clipboard.setData(
          ClipboardData(text: _supplierModel?.address ?? ''));
      Messages.info('Endereço copiado!');
    }
  }

  void goToSchedule() {
    Modular.to.pushNamed('/schedules/',
        arguments: SchedulesViewModel(
          services: _servicesSupplierSelected.toList(),
          supplierID: _supplierID,
        ));
  }
}
