// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SupplierServiceModel {
  final int id;
  final String supplierID;
  final String name;
  final double price;

  SupplierServiceModel(
      {required this.id,
      required this.supplierID,
      required this.name,
      required this.price});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'supplier_id': supplierID,
      'name': name,
      'price': price,
    };
  }

  factory SupplierServiceModel.fromMap(Map<String, dynamic> map) {
    return SupplierServiceModel(
      id: map['id']?.toInt() ?? 0,
      supplierID : map['supplier_id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SupplierServiceModel.fromJson(String source) => SupplierServiceModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
