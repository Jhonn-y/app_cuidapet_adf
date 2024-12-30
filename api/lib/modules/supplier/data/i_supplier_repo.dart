import 'package:cuidapet_api/dtos/supplier_near_by_me_dto.dart';

abstract class ISupplierRepo {
  Future<List<SupplierNearByMeDto>> findNearByPosition(double lat, double long, int distance);

}