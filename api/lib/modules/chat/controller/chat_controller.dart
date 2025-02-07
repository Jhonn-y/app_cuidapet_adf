// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/chat/service/i_chat_service.dart';
import 'package:cuidapet_api/modules/chat/view_models/notify_user_view_model.dart';
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

  @Route.post('/notify')
  Future<Response> notifyUser(Request request) async {
    try {
      final model = NotifyUserViewModel(await request.readAsString());
      await service.notifyChat(model);
      return Response.ok(jsonEncode({}));
    } catch (e) {
      return Response.internalServerError();
    }
  }

  @Route.get('/users')
  Future<Response> findChatsByUser(Request request) async {
    try {
      final user = int.parse(request.headers['user']!);
      final chats = await service.getChatsByUser(user);

      final resultChats = chats
          .map((c) => {
                'id': c.id,
                'user': c.user,
                'name': c.name,
                'pet_name': c.petName,
                'supplier': {
                  'id': c.supplier.id,
                  'name': c.supplier.name,
                  'logo': c.supplier.logo,
                }
              })
          .toList();

      return Response.ok(jsonEncode(resultChats));
    } catch (e) {
      log.error('Erro ao buscar chats por usuário', e);
      return Response.internalServerError();
    }
  }

  @Route.get('/supplier')
  Future<Response> findChatsBySupplier(Request request) async {
    try {
      final supplier = request.headers['supplier'];
      if (supplier == null) {
        return Response(400,
            body: jsonEncode({'message': 'Usuario não é um fornecedor!'}));
      }
      final supplierID = int.parse(supplier);
      final chats = await service.getChatsBySupplier(supplierID);

      final resultChats = chats
          .map((c) => {
                'id': c.id,
                'user': c.user,
                'name': c.name,
                'pet_name': c.petName,
                'supplier': {
                  'id': c.supplier.id,
                  'name': c.supplier.name,
                  'logo': c.supplier.logo,
                }
              })
          .toList();

      return Response.ok(jsonEncode(resultChats));
    } catch (e) {
      log.error('Erro ao buscar chats por fornecedor', e);
      return Response.internalServerError();
    }
  }

  @Route.put('/<chatID>/end-chat')
  Future<Response> endChat(Request request, String chatID) async {
    try {
      await service.endChat(int.parse(chatID));

      return Response.ok(jsonEncode({}));
    } catch (e) {
      log.error('Erro ao encerrar chat', e);
      return Response.internalServerError();
    }
  }

  Router get router => _$ChatControllerRouter(this);
}
