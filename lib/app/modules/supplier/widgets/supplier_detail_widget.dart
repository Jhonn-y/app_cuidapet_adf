import 'package:flutter/material.dart';
import 'package:projeto_cuidapet/app/core/ui/extensions/theme_extension.dart';
import 'package:projeto_cuidapet/app/model/supplier_model.dart';
import 'package:projeto_cuidapet/app/modules/supplier/supplier_controller.dart';

class SupplierDetailWidget extends StatelessWidget {
  final SupplierModel _supplier;
  final SupplierController _controller;

  const SupplierDetailWidget(
      {super.key,
      required SupplierModel supplier,
      required SupplierController controller})
      : _supplier = supplier,
        _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Center(
            child: Text(
              _supplier.name,
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Divider(
          thickness: 1,
          color: context.primaryColor,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Informações do estabelecimento:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
        ListTile(
          onTap: () {
            _controller.goToGeoOrCopyPhoneToClipart();
          },
          leading: Icon(
            Icons.location_city,
            color: Colors.black,
          ),
          title: Text(_supplier.address),
        ),
        ListTile(
          onTap: () {
            _controller.goToPhoneOrCopyPhoneToClipart();
          },
          leading: Icon(
            Icons.local_phone,
            color: Colors.black,
          ),
          title: Text(_supplier.phone),
        ),
        Divider(
          thickness: 1,
          color: context.primaryColor,
        ),
      ],
    );
  }
}
