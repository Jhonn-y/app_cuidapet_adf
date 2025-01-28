import 'package:projeto_cuidapet/app/entities/address_entity.dart';
import 'package:projeto_cuidapet/app/model/supplier_category_model.dart';
import 'package:projeto_cuidapet/app/model/supplier_near_by_me_model.dart';
import 'package:projeto_cuidapet/app/repo/supplier/i_supplier_repo.dart';

import './i_supplier_service.dart';

class SupplierService implements ISupplierService {
  final ISupplierRepo _supplierRepo;

  SupplierService({required ISupplierRepo supplierRepo})
      : _supplierRepo = supplierRepo;

  @override
  Future<List<SupplierCategoryModel>> getCategories() =>
      _supplierRepo.getCategories();

  @override
  Future<List<SupplierNearByMeModel>> findNearBy(AddressEntity addressEntity) =>
      _supplierRepo.findNearBy(addressEntity);
}
