
import 'package:cuidapet_api/application/router/i_router.dart';
import 'package:cuidapet_api/modules/categories/controller/categories_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/src/router.dart';

class CategoriesRouter  implements IRouter{
  @override
  void configure(Router route) {
    final categoryController = GetIt.I<CategoriesController>();

    route.mount('/categories/', categoryController.router.call);
  }
  
}