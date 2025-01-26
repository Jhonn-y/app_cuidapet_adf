import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:projeto_cuidapet/app/core/life_cycle/page_life_cycle_state.dart';
import 'package:projeto_cuidapet/app/core/mixins/location_mixin.dart';
import 'package:projeto_cuidapet/app/core/ui/extensions/theme_extension.dart';
import 'package:projeto_cuidapet/app/model/place_model.dart';
import 'package:projeto_cuidapet/app/modules/address/address_controller.dart';
import 'package:projeto_cuidapet/app/modules/address/widgets/address_search_widget/address_search_controller.dart';

part './widgets/address_item.dart';
part 'widgets/address_search_widget/address_search_widget.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState
    extends PageLifeCycleState<AddressController, AddressPage>
    with LocationMixin {
  final reactorDisposers = <ReactionDisposer>[];

  @override
  void initState() {
    super.initState();
    final reactionService =
        reaction<bool>((_) => controller.locationServiceUnavailable,
            (locationServiceUnavailable) {
      if (locationServiceUnavailable) {
        showDialogLocationUnavailable();
      }
    });
    final reactionLocationPermission = reaction<LocationPermission?>(
        (_) => controller.locationPermission, (locationPermission) {
      if (locationPermission != null &&
          locationPermission == LocationPermission.denied) {
        showDialogLocationDenied(() => controller.getMyLocation());
      } else {
        if (locationPermission != null &&
            locationPermission == LocationPermission.denied) {
          showDialogLocationDeniedForever();
        }
      }
    });
    reactorDisposers.addAll([reactionService, reactionLocationPermission]);
  }

  @override
  void dispose() {
    super.dispose();
    for (var reaction in reactorDisposers) {
      reaction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (await controller.addressWasSelected()) {
          Modular.to.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: context.primaryColorDark),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(13),
            child: Column(
              children: [
                Text(
                  'Adicione ou escolha um endereço',
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Observer(
                  builder: (_) {
                    return _AddressSearchWidget(
                      key: UniqueKey(),
                      addressSelectedCallback: (place) {
                        controller.goToAddressDetailPage(place);
                      },
                      place: controller.placeModel,
                    );
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                ListTile(
                  onTap: () => controller.getMyLocation(),
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 30,
                    child: Icon(
                      Icons.near_me,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Localização Atual',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Observer(
                  builder: (_) {
                    return Column(
                      children: controller.address
                          .map((a) => _AddressItem(
                                address: a.address,
                                callback: () {
                                  controller.selectAddress(a);
                                },
                                additional: a.additional,
                              ))
                          .toList(),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
