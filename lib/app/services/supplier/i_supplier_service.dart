import 'package:projeto_cuidapet/app/entities/address_entity.dart';
import 'package:projeto_cuidapet/app/model/supplier_category_model.dart';
import 'package:projeto_cuidapet/app/model/supplier_model.dart';
import 'package:projeto_cuidapet/app/model/supplier_near_by_me_model.dart';
import 'package:projeto_cuidapet/app/model/supplier_service_model.dart';

abstract class ISupplierService {
  Future<List<SupplierCategoryModel>> getCategories();
  Future<List<SupplierNearByMeModel>> findNearBy(AddressEntity addressEntity);
  Future<SupplierModel> findById(int id);
  Future<List<SupplierServiceModel>> findServices(int supplierID);

}
