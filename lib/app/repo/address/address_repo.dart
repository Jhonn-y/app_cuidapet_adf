// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_place/google_place.dart';

import 'package:projeto_cuidapet/app/core/database/sqlite_conn_factory.dart';
import 'package:projeto_cuidapet/app/core/exceptions/failure.dart';
import 'package:projeto_cuidapet/app/core/helpers/environments.dart';
import 'package:projeto_cuidapet/app/entities/address_entity.dart';
import 'package:projeto_cuidapet/app/model/place_model.dart';

import './i_address_repo.dart';

class AddressRepo implements IAddressRepo {
  final SqliteConnFactory _sqliteConnectionFactory;
  AddressRepo({
    required SqliteConnFactory sqliteConnectionFactory,
  }) : _sqliteConnectionFactory = sqliteConnectionFactory;

  @override
  Future<List<PlaceModel>> findAddressByGooglePlaces(
      String addressPattern) async {
    final googleApiKey = Environments.param('google_api_key');

    if (googleApiKey == null) {
      throw Failure(message: 'Google API key not found');
    }

    final googlePlace = GooglePlace(googleApiKey);

    final addressResult =
        await googlePlace.search.getTextSearch(addressPattern);
    final candidates = addressResult?.results;

    if (candidates != null) {
      return candidates.map<PlaceModel>((searchResult) {
        final location = searchResult.geometry?.location;
        final address = searchResult.formattedAddress;

        return PlaceModel(
            address: address ?? '',
            lat: location?.lat ?? 0,
            lng: location?.lng ?? 0);
      }).toList();
    }

    return <PlaceModel>[];
  }

  @override
  Future<List<AddressEntity>> getAddress() async {
    final sqliteConn = await _sqliteConnectionFactory.openConnection();
    
    final result = await sqliteConn.rawQuery('SELECT * FROM address');
    return result.map<AddressEntity>((a)=> AddressEntity.fromMap(a)).toList();
  }

  @override
  Future<void> deleteAll() async {
    final sqliteConn = await _sqliteConnectionFactory.openConnection();
    await sqliteConn.delete('address');
  }

  @override
  Future<int> saveAddress(AddressEntity entity) async {
    final sqliteConn = await _sqliteConnectionFactory.openConnection();
    
    return await sqliteConn.rawInsert('INSERT INTO address VALUES (?,?,?,?,?)',[
      null,
      entity.address,
      entity.lat,
      entity.lng,
      entity.additional,

    ]);
  }
}
