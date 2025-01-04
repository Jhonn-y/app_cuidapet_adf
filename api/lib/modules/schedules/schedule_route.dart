// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cuidapet_api/application/router/i_router.dart';
import 'package:cuidapet_api/modules/schedules/controller/schedule_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/src/router.dart';

class ScheduleRoute implements IRouter {

  @override
  void configure(Router route) {
    final scheduleController = GetIt.I<ScheduleController>();
    route.mount('/schedule/', scheduleController.router.call);
  }
  
}
