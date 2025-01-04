class SupplierService {
  final int id;
  final int? supplierID;
  final String? name;
  final double? price;

  SupplierService(
      {required this.id,
      this.supplierID,
      this.name,
      this.price});
}
