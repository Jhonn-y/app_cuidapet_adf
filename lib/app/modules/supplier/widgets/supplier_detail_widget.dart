import 'package:flutter/material.dart';
import 'package:projeto_cuidapet/app/core/ui/extensions/theme_extension.dart';
import 'package:projeto_cuidapet/app/model/supplier_model.dart';

class SupplierDetailWidget extends StatelessWidget {
  final SupplierModel _supplier;
  const SupplierDetailWidget({super.key, required SupplierModel supplier})
      : _supplier = supplier;

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
          leading: Icon(
            Icons.location_city,
            color: Colors.black,
          ),
          title: Text(_supplier.address),
        ),
        ListTile(
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
