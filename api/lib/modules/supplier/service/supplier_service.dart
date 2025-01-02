import 'package:cuidapet_api/dtos/supplier_near_by_me_dto.dart';
import 'package:cuidapet_api/entities/supplier.dart';
import 'package:cuidapet_api/entities/supplier_service.dart' as entity;
import 'package:cuidapet_api/modules/supplier/data/i_supplier_repo.dart';
import 'package:injectable/injectable.dart';

import './i_supplier_service.dart';

@LazySingleton(as: ISupplierService)
class SupplierService implements ISupplierService {
  final ISupplierRepo supRepo;
  static const DISTANCE = 5;

  SupplierService({required this.supRepo});

  @override
  Future<List<SupplierNearByMeDto>> findNearByHere(double lat, double long) =>
      supRepo.findNearByPosition(lat, long, DISTANCE);

  @override
  Future<Supplier?> findByID(int id) => supRepo.findByID(id);

  @override
  Future<List<entity.SupplierService>> findServicesBySupplierID(int supId) => supRepo.findServicesBySupplierID(supId);
  
  @override
  Future<bool> checkUserExists(String email) => supRepo.checkUserExists(email);
}
