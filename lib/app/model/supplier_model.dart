// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projeto_cuidapet/app/model/supplier_category_model.dart';

class SupplierModel {
  final int id;
  final String name;
  final String logo;
  final String address;
  final String phone;
  final double lat;
  final double lng;
  final SupplierCategoryModel categoryModel;

  SupplierModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.address,
    required this.phone,
    required this.lat,
    required this.lng,
    required this.categoryModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'logo': logo,
      'address': address,
      'phone': phone,
      'latitude': lat,
      'longitude': lng,
      'categoryModel': categoryModel.toMap(),
    };
  }

  factory SupplierModel.fromMap(Map<String, dynamic> map) {
    return SupplierModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      logo: map['logo'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      lat: map['latitude'].toDouble() ?? 0.0,
      lng: map['longitude'].toDouble() ?? 0.0,
      categoryModel: SupplierCategoryModel.fromMap(map['categoryModel'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SupplierModel.fromJson(String source) => SupplierModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
