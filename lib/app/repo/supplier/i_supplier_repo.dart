import 'package:projeto_cuidapet/app/model/supplier_category_model.dart';

abstract class ISupplierRepo {
  Future<List<SupplierCategoryModel>> getCategories();
}