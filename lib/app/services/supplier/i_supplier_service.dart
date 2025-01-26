import 'package:projeto_cuidapet/app/model/supplier_category_model.dart';

abstract class ISupplierService {
  Future<List<SupplierCategoryModel>> getCategories();
}
