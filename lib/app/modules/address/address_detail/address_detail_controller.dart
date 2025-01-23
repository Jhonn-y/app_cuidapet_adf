import 'package:mobx/mobx.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/loader.dart';
import 'package:projeto_cuidapet/app/entities/address_entity.dart';
import 'package:projeto_cuidapet/app/model/place_model.dart';
import 'package:projeto_cuidapet/app/services/address/i_address_service.dart';
part 'address_detail_controller.g.dart';

class AddressDetailController = _AddressDetailControllerBase
    with _$AddressDetailController;

abstract class _AddressDetailControllerBase with Store {
  final IAddressService _addressService;

  @readonly
  AddressEntity? _addressEntity;

  _AddressDetailControllerBase({required IAddressService addressService})
      : _addressService = addressService;


  Future<void> saveAddress(PlaceModel model,String additional) async {
    Loader.show();
    final addressEntity = await _addressService.saveAddress(model,additional);
    Loader.hide();
    _addressEntity = addressEntity;
  }
}
