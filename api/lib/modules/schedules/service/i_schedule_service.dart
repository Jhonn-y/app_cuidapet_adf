import 'package:cuidapet_api/entities/schedule.dart';
import 'package:cuidapet_api/modules/schedules/view_models/schedule_save_input_model.dart';

abstract class IScheduleService {

  Future<void> scheduleService(ScheduleSaveInputModel model);
  Future<void> changeStatus(String status, int scheduleID);
  Future<List<Schedule>> findAllScheduleByUser(int userID);
  Future<List<Schedule>> findAllschedulesByUserSupplier(int userID);
}