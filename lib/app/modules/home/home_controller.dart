import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:projeto_cuidapet/app/core/life_cycle/controller_life_cycle.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/loader.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/messages.dart';
import 'package:projeto_cuidapet/app/entities/address_entity.dart';
import 'package:projeto_cuidapet/app/model/supplier_category_model.dart';
import 'package:projeto_cuidapet/app/services/address/i_address_service.dart';
import 'package:projeto_cuidapet/app/services/supplier/i_supplier_service.dart';
part 'home_controller.g.dart';

enum SupplierPageType { list, grid }

// ignore: library_private_types_in_public_api
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store, ControllerLifeCycle {
  final IAddressService _addressService;
  final ISupplierService _supplierService;

  _HomeControllerBase(
      {required ISupplierService supplierService,
      required IAddressService addressService})
      : _addressService = addressService,
        _supplierService = supplierService;

  @readonly
  AddressEntity? _addressEntity;

  @readonly
  var _listCategories = <SupplierCategoryModel>[];

  @readonly
  SupplierPageType _pageTypeSelected = SupplierPageType.list;

  @override
  Future<void> onReady() async {
    try {
      Loader.show();
      await _getAddressSelected();
      // await _getCategories();
    } finally {
      Loader.hide();
    }
  }

  @action
  Future<void> _getAddressSelected() async {
    _addressEntity ??= await _addressService.getSelectedAddress();

    if (_addressEntity == null) {
      await goToAddressPage();
    }
  }

  @action
  Future<void> goToAddressPage() async {
    final address = await Modular.to.pushNamed<AddressEntity>('/address/');
    if (address != null) {
      _addressEntity = address;
    }
  }

  @action
  Future<void> _getCategories() async {
    try {
      final categories = await _supplierService.getCategories();
      _listCategories = [...categories];
    } catch (e) {
      Messages.alert('Erro ao buscar categorias');
      throw Exception();
    }
  }

  @action
  void changeTabSupplier(SupplierPageType type){
    _pageTypeSelected = type;
  }
}
