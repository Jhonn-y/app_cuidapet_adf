
import 'package:cuidapet_api/application/router/i_router.dart';
import 'package:cuidapet_api/modules/categories/categories_router.dart';
import 'package:cuidapet_api/modules/supplier/supplier_route.dart';
import 'package:cuidapet_api/modules/user/user_router.dart';
import 'package:shelf_router/shelf_router.dart';

class RouterConfigure {
  
  final Router _router;
  final List<IRouter> _routers = [
    UserRouter(),
    CategoriesRouter(),
    SupplierRoute(),
  ];

  RouterConfigure(this._router);
  
  void configure() => _routers.forEach((r) => r.configure(_router));
}