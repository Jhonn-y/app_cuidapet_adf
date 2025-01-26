import 'package:flutter_modular/flutter_modular.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:projeto_cuidapet/app/core/life_cycle/controller_life_cycle.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/loader.dart';
import 'package:projeto_cuidapet/app/entities/address_entity.dart';
import 'package:projeto_cuidapet/app/model/place_model.dart';
import 'package:projeto_cuidapet/app/services/address/i_address_service.dart';
part 'address_controller.g.dart';

class AddressController = _AddressControllerBase with _$AddressController;

abstract class _AddressControllerBase with Store, ControllerLifeCycle {
  final IAddressService _addressService;

  @readonly
  var _address = <AddressEntity>[];

  @readonly
  var _locationServiceUnavailable = false;

  @readonly
  LocationPermission? _locationPermission;

  @readonly
  PlaceModel? _placeModel;

  _AddressControllerBase({required IAddressService addressService})
      : _addressService = addressService;

  @override
  void onReady() {
    getAddress();
  }

  @action
  Future<void> getAddress() async {
    Loader.show();
    _address = await _addressService.getAddress();
    Loader.hide();
  }

  @action
  Future<void> getMyLocation() async {

    _locationPermission = null;
    _locationServiceUnavailable = false;

    final serviceEnable = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnable) {
      _locationServiceUnavailable = true;
      return;
    }

    final locationPermission = await Geolocator.checkPermission();

    switch (locationPermission) {
      case LocationPermission.denied:
        final permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          _locationPermission = permission;
          return;
        }
        break;
      case LocationPermission.deniedForever:
        _locationPermission = locationPermission;
        return;

      case LocationPermission.whileInUse:
      case LocationPermission.always:
      case LocationPermission.unableToDetermine:
        break;
    }

    Loader.show();
    final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high));

    final placeMark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final place = placeMark.first;
    final address = '${place.thoroughfare} ${place.subThoroughfare}';
    final placeModel = PlaceModel(
        address: address, lat: position.latitude, lng: position.longitude);

    Loader.hide();
    goToAddressDetailPage(placeModel);
  }

  Future<void> goToAddressDetailPage(PlaceModel place) async {
    final address = await Modular.to.pushNamed('/address/detail/', arguments: place);

    if(address is PlaceModel){
      _placeModel = address;
    }
  }
}
