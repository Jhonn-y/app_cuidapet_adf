import 'package:cuidapet_api/entities/schedule.dart';

abstract class IScheduleRepo {

  Future<void> save(Schedule schedule);

}