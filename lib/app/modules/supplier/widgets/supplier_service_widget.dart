import 'package:flutter/material.dart';
import 'package:projeto_cuidapet/app/core/ui/extensions/theme_extension.dart';

class SupplierServiceWidget extends StatelessWidget {
  const SupplierServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.pets),
      ),
      title: Text('banho'),
      subtitle: Text(r'R$10,00'),
      trailing: Icon(
        Icons.add_circle,
        size: 30,
        color: context.primaryColor,
      ),
    );
  }
}
