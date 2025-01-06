// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/chat/service/i_chat_service.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'chat_controller.g.dart';

@injectable
class ChatController {
  ILogger log;
  IChatService service;
  ChatController({
    required this.log,
    required this.service,
  });

  @Route.post('/schedule/<scheduleID>/start-chat')
  Future<Response> startChatByScheduleID(
      Request request, String scheduleID) async {
    try {
      final chatID = await service.startChat(int.parse(scheduleID));

      return Response.ok(jsonEncode({'chat_id': chatID}));
    } catch (e) {
      log.error('Erro ao iniciar chat', e);
      return Response.internalServerError();
    }
  }

  Router get router => _$ChatControllerRouter(this);
}
