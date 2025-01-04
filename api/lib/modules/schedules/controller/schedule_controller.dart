// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/schedules/service/i_schedule_service.dart';
import 'package:cuidapet_api/modules/schedules/view_models/schedule_save_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'schedule_controller.g.dart';

@injectable
class ScheduleController {
  IScheduleService service;
  ILogger log;
  ScheduleController({
    required this.service,
    required this.log,
  });

  @Route.get('/')
  Future<Response> scheduleServices(Request request) async {
    try {
      final userID = int.parse(request.headers['user']!);

      final inputModel = ScheduleSaveInputModel(
          userID: userID, dataRequest: await request.readAsString());

      await service.scheduleService(inputModel);

      return Response.ok(jsonEncode({}));
    } catch (e) {
      log.error('Erro ao salvar agendamento', e);
      return Response.internalServerError();
    }
  }

  @Route.put('/<scheduleID|[0-9]+>/status/<status>')
  Future<Response> changeStatus(
      Request request, String scheduleID,String status) async {
    try {
      await service.changeStatus(status, int.parse(scheduleID));
      return Response.ok(jsonEncode({}));
    } catch (e) {
      log.error('Erro ao alterar status do agendamento', e);
      return Response.internalServerError();
    }
  }

  Router get router => _$ScheduleControllerRouter(this);
}
