import 'package:projeto_cuidapet/app/entities/address_entity.dart';
import 'package:projeto_cuidapet/app/model/place_model.dart';

abstract class IAddressService {
  Future<List<PlaceModel>> findAddressByGooglePlaces(String addressPattern);
  Future<List<AddressEntity>> getAddress();
  Future<AddressEntity> saveAddress(PlaceModel model, String additional);
  Future<void> deleteAll();
  Future<void> selectAddress(AddressEntity entity);
  Future<AddressEntity?> getSelectedAddress();
}
