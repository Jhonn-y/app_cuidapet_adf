import 'package:cuidapet_api/dtos/supplier_near_by_me_dto.dart';
import 'package:cuidapet_api/entities/supplier.dart';
import 'package:cuidapet_api/entities/supplier_service.dart';
import 'package:cuidapet_api/modules/supplier/view_models/create_supplier_user_view_model.dart';

abstract class ISupplierService {
  Future<List<SupplierNearByMeDto>> findNearByHere(double lat, double long);
  Future<Supplier?> findByID(int id);
  Future<List<SupplierService>> findServicesBySupplierID(int supId);
  Future<bool> checkUserExists(String email);
  Future<void> createUserSupplier(CreateSupplierUserViewModel model);
}