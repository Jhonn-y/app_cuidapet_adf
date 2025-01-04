import 'package:cuidapet_api/dtos/supplier_near_by_me_dto.dart';
import 'package:cuidapet_api/entities/categories.dart';
import 'package:cuidapet_api/entities/supplier.dart';
import 'package:cuidapet_api/entities/supplier_service.dart' as entity;
import 'package:cuidapet_api/modules/supplier/data/i_supplier_repo.dart';
import 'package:cuidapet_api/modules/supplier/view_models/create_supplier_user_view_model.dart';
import 'package:cuidapet_api/modules/supplier/view_models/supplier_update_input_model.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';

import './i_supplier_service.dart';

@LazySingleton(as: ISupplierService)
class SupplierService implements ISupplierService {
  final ISupplierRepo supRepo;
  final IUserService userService;
  static const DISTANCE = 5;

  SupplierService({ required this.userService,required this.supRepo});

  @override
  Future<List<SupplierNearByMeDto>> findNearByHere(double lat, double long) =>
      supRepo.findNearByPosition(lat, long, DISTANCE);

  @override
  Future<Supplier?> findByID(int id) => supRepo.findByID(id);

  @override
  Future<List<entity.SupplierService>> findServicesBySupplierID(int supId) => supRepo.findServicesBySupplierID(supId);
  
  @override
  Future<bool> checkUserExists(String email) => supRepo.checkUserExists(email);

  @override
  Future<void> createUserSupplier(CreateSupplierUserViewModel model) async {
    final supplierEntity = Supplier(
      name: model.supplierName,
      category: Categories(id: model.category)
    );

    final supplierID = await supRepo.saveSupplier(supplierEntity);

    final userInputModel = UserSaveInputModel(
      email: model.email,
      password: model.password,
      supplierID: supplierID,
      );

      await userService.createUser(userInputModel);
  }

  @override
  Future<Supplier> update(SupplierUpdateInputModel model) async {
    
    final supplierObj = Supplier(
      id: model.supplierID,
      name: model.name,
      address: model.address,
      lat: model.lat,
      lng: model.lng,
      logo: model.logo,
      phone: model.phone,
      category: Categories(id: model.categoryID),
    );
    
    return await supRepo.update(supplierObj);
  }
}
