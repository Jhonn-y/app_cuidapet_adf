import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_cuidapet/app/core/helpers/text_format.dart';
import 'package:projeto_cuidapet/app/core/ui/extensions/theme_extension.dart';
import 'package:projeto_cuidapet/app/model/supplier_service_model.dart';
import 'package:projeto_cuidapet/app/modules/supplier/supplier_controller.dart';

class SupplierServiceWidget extends StatelessWidget {
  final SupplierServiceModel _serviceModel;
  final SupplierController _controller;
  const SupplierServiceWidget(
      {super.key,
      required SupplierServiceModel serviceModel,
      required SupplierController controller})
      : _serviceModel = serviceModel,
        _controller = controller;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.pets),
        ),
        title: Text(_serviceModel.name),
        subtitle: Text(TextFormat.formatReal(_serviceModel.price)),
        trailing: Observer(
          builder: (_) {
            return IconButton(
              onPressed: () {
                _controller.addOrRemoveService(_serviceModel);
              },
              icon: _controller.isServiceSelected(_serviceModel)
                  ? Icon(
                      Icons.remove_circle,
                      size: 30,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.add_circle,
                      size: 30,
                      color: context.primaryColor,
                    ),
            );
          },
        ));
  }
}
