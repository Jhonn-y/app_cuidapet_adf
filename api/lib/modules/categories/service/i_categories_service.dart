import 'package:cuidapet_api/entities/categories.dart';

abstract class ICategoriesService {

  Future<List<Categories>> find();
}