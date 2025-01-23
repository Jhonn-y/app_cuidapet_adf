import 'package:projeto_cuidapet/app/entities/address_entity.dart';
import 'package:projeto_cuidapet/app/model/place_model.dart';
import 'package:projeto_cuidapet/app/repo/address/i_address_repo.dart';

import './i_address_service.dart';

class AddressService implements IAddressService {
  final IAddressRepo _addressRepo;

  AddressService({required IAddressRepo addressRepo})
      : _addressRepo = addressRepo;

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
      additional: additional
    );
    final result = await _addressRepo.saveAddress(entity);

    return entity.copyWith(id:result);
  }
}
