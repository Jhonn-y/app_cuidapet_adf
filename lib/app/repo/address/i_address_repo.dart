import 'package:projeto_cuidapet/app/model/place_model.dart';

abstract class IAddressRepo {
  Future<List<PlaceModel>> findAddressByGooglePlaces(String addressPattern);
}
