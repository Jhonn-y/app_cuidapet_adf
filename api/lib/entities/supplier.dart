import 'package:cuidapet_api/entities/categories.dart';

class Supplier {
  final int? id;
  final String? name;
  final String? logo;
  final String? address;
  final String? phone;
  final double? lat;
  final double? lng;
  final Categories? category;

  Supplier({
    this.id,
    this.name,
    this.logo,
    this.address,
    this.phone,
    this.lat,
    this.lng,
    this.category,
  });
}
