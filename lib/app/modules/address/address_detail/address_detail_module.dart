
import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/model/place_model.dart';
import 'package:projeto_cuidapet/app/modules/address/address_detail/address_detail_page.dart';
import 'package:projeto_cuidapet/app/modules/address/address_module.dart';

class AddressDetailModule extends Module {
  @override
  void binds(Injector i) {
    // TODO: implement binds
    super.binds(i);
  }

  @override
  List<Module> get imports => [
        AddressModule(),
      ];

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (context) => AddressDetailPage(place: PlaceModel(address: 'address', lat: 0, lng: 0),),
    );
  }


}
