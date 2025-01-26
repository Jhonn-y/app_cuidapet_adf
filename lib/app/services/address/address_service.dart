import 'package:projeto_cuidapet/app/core/helpers/constants.dart';
import 'package:projeto_cuidapet/app/core/local_storage/local_storage.dart';
import 'package:projeto_cuidapet/app/entities/address_entity.dart';
import 'package:projeto_cuidapet/app/model/place_model.dart';
import 'package:projeto_cuidapet/app/repo/address/i_address_repo.dart';

import './i_address_service.dart';

class AddressService implements IAddressService {
  final IAddressRepo _addressRepo;
  final LocalStorage _localStorage;

  AddressService(
      {required IAddressRepo addressRepo, required LocalStorage localStorage})
      : _localStorage = localStorage,
        _addressRepo = addressRepo;

  @override
  Future<List<PlaceModel>> findAddressByGooglePlaces(String addressPattern) =>
      _addressRepo.findAddressByGooglePlaces(addressPattern);

  @override
  Future<void> deleteAll() => _addressRepo.deleteAll();

  @override
  Future<List<AddressEntity>> getAddress() => _addressRepo.getAddress();

  @override
  Future<AddressEntity> saveAddress(PlaceModel model, String additional) async {
    final entity = AddressEntity(
        address: model.address,
        lat: model.lat,
        lng: model.lng,
        additional: additional);
    final result = await _addressRepo.saveAddress(entity);

    return entity.copyWith(id: result);
  }

  @override
  Future<AddressEntity?> getSelectedAddress() async {
    final addressJson = await _localStorage
        .read<String>(Constants.LOCAL_STORAGE_DEFAULT_ADDRESS_DATA_KEY);

    if (addressJson != null) {
      return AddressEntity.fromJson(addressJson);
    }
    return null;
  }

  @override
  Future<void> selectAddress(AddressEntity entity) async {
    await _localStorage.write<String>(
        Constants.LOCAL_STORAGE_DEFAULT_ADDRESS_DATA_KEY, entity.toJson());
  }
}
