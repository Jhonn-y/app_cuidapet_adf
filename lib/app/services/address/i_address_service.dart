import 'package:projeto_cuidapet/app/model/place_model.dart';

abstract class IAddressService {
  Future<List<PlaceModel>> findAddressByGooglePlaces(String addressPattern);
}
