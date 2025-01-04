// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cuidapet_api/entities/schedule.dart';
import 'package:cuidapet_api/entities/schedule_supplier_entity.dart';
import 'package:cuidapet_api/entities/supplier.dart';
import 'package:cuidapet_api/entities/supplier_service.dart';
import 'package:cuidapet_api/modules/schedules/data/i_schedule_repo.dart';
import 'package:cuidapet_api/modules/schedules/view_models/schedule_save_input_model.dart';
import 'package:injectable/injectable.dart';

import './i_schedule_service.dart';

@LazySingleton(as: IScheduleService)
class ScheduleService implements IScheduleService {

  final IScheduleRepo scheduleRepo;
  ScheduleService({
    required this.scheduleRepo,
  });



  @override
  Future<void> scheduleService(ScheduleSaveInputModel model) async {
    final schedule = Schedule(
        scheduleDate: model.scheduleDate,
        name: model.name,
        petName: model.petName,
        supplier: Supplier(id: model.supplierID),
        status: 'P',
        userID: model.userID,
        services: model.services.map(
            (e) => ScheduleSupplierEntity(service: SupplierService(id: e))).toList());

    await scheduleRepo.save(schedule);
  }
  
  @override
  Future<void> changeStatus(String status, int scheduleID) => scheduleRepo.changeStatus(status, scheduleID);
}
