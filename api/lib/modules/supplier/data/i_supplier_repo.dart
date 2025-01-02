import 'package:cuidapet_api/dtos/supplier_near_by_me_dto.dart';
import 'package:cuidapet_api/entities/supplier.dart';

abstract class ISupplierRepo {
  Future<List<SupplierNearByMeDto>> findNearByPosition(double lat, double long, int distance);
  Future<Supplier?> findByID(int id);

}