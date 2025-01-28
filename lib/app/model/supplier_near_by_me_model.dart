import 'dart:convert';

class SupplierNearByMeModel {
  final int id;
  final String name;
  final String logo;
  final double distance;
  final int category;

  SupplierNearByMeModel(
      {required this.id,
      required this.name,
      required this.logo,
      required this.distance,
      required this.category});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'logo': logo,
      'distance': distance,
      'category': category,
    };
  }

  factory SupplierNearByMeModel.fromMap(Map<String, dynamic> map) {
    return SupplierNearByMeModel(
      id: map['id'] as int,
      name: map['name'] as String,
      logo: map['logo'] as String,
      distance: map['distance'] as double,
      category: map['category'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SupplierNearByMeModel.fromJson(String source) =>
      SupplierNearByMeModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
