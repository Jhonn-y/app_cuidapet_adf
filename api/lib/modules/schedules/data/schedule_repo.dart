import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import './i_schedule_repo.dart';

@LazySingleton(as: IScheduleRepo)
class ScheduleRepo implements IScheduleRepo {

  MySqlConnection? connection;

}