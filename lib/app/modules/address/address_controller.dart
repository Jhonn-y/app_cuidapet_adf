import 'package:mobx/mobx.dart';
import 'package:projeto_cuidapet/app/core/life_cycle/controller_life_cycle.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/loader.dart';
import 'package:projeto_cuidapet/app/entities/address_entity.dart';
import 'package:projeto_cuidapet/app/services/address/i_address_service.dart';
part 'address_controller.g.dart';

class AddressController = _AddressControllerBase with _$AddressController;

abstract class _AddressControllerBase with Store, ControllerLifeCycle {

  final IAddressService _addressService;

  @readonly
  List<AddressEntity> _address = [];

  _AddressControllerBase({required IAddressService addressService})
      : _addressService = addressService;


  @override
  void onReady(){
    getAddress();
  }


  @action
  Future<void> getAddress() async {
    Loader.show();
    _address = await _addressService.getAddress();
    Loader.hide();
    
  }
}
