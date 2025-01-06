// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:cuidapet_api/application/database/i_database_conn.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/chat/service/i_chat_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'chat_controller.g.dart';

class ChatController {
  IDatabaseConn connection;
  ILogger log;
  IChatService service;
  ChatController({
    required this.connection,
    required this.log,
    required this.service,
  });


  @Route.get('/')
  Future<Response> find(Request request) async {
    return Response.ok(jsonEncode(''));
  }

  Router get router => _$ChatControllerRouter(this);
}
