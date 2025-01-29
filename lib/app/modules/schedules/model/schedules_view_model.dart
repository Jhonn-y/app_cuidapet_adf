import 'package:projeto_cuidapet/app/model/supplier_service_model.dart';

class SchedulesViewModel {
  final int supplierID;
  final List<SupplierServiceModel> services;

  SchedulesViewModel({required this.supplierID, required this.services});
}
