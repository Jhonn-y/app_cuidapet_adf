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
}
