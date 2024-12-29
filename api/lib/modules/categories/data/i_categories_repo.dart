import 'package:cuidapet_api/entities/categories.dart';

abstract class ICategoriesRepo {
  Future<List<Categories>> find();
}