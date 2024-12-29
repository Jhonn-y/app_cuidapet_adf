// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/entities/categories.dart';
import 'package:cuidapet_api/modules/categories/data/i_categories_repo.dart';
import 'package:injectable/injectable.dart';

import './i_categories_service.dart';

@LazySingleton(as: ICategoriesService)
class CategoriesService implements ICategoriesService {

  ICategoriesRepo repo;
  CategoriesService({
    required this.repo,
  });

  @override
  Future<List<Categories>> find() => repo.find();

}
