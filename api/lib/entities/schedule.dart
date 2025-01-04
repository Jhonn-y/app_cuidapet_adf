import 'package:cuidapet_api/entities/schedule_supplier_entity.dart';
import 'package:cuidapet_api/entities/supplier.dart';

class Schedule {
  final int? id;
  final DateTime scheduleDate;
  final String status;
  final String name;
  final String petName;
  final int userID;
  final Supplier supplier;
  final List<ScheduleSupplierEntity> services;

  Schedule(
      { this.id,
      required this.scheduleDate,
      required this.status,
      required this.name,
      required this.petName,
      required this.userID,
      required this.supplier,
      required this.services});
}
