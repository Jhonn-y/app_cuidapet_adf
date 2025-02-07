import 'package:cuidapet_api/entities/schedule.dart';

abstract class IScheduleRepo {

  Future<void> save(Schedule schedule);
  Future<void> changeStatus(String status, int scheduleID);
  Future<List<Schedule>> findAllschedulesByUser(int userID);
  Future<List<Schedule>> findAllschedulesByUserSupplier(int userID);

}