import 'package:flutter/material.dart';
import 'package:projeto_cuidapet/app/core/helpers/text_format.dart';
import 'package:projeto_cuidapet/app/core/ui/extensions/theme_extension.dart';
import 'package:projeto_cuidapet/app/model/supplier_service_model.dart';

class SupplierServiceWidget extends StatelessWidget {
  final SupplierServiceModel _serviceModel;
  const SupplierServiceWidget(
      {super.key, required SupplierServiceModel serviceModel})
      : _serviceModel = serviceModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.pets),
      ),
      title: Text(_serviceModel.name),
      subtitle: Text(TextFormat.formatReal(_serviceModel.price)),
      trailing: Icon(
        Icons.add_circle,
        size: 30,
        color: context.primaryColor,
      ),
    );
  }
}
