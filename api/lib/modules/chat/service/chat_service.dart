// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/application/facades/push_notification_facade.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/chat.dart';
import 'package:cuidapet_api/modules/chat/data/i_chat_repo.dart';
import 'package:cuidapet_api/modules/chat/view_models/notify_user_view_model.dart';
import 'package:injectable/injectable.dart';

import './i_chat_service.dart';

@LazySingleton(as: IChatService)
class ChatService implements IChatService {
  IChatRepo chatRepo;
  ILogger log;
  final PushNotificationFacade facade;

  ChatService({
    required this.facade,
    required this.chatRepo,
    required this.log,
  });

  @override
  Future<int> startChat(int scheduleID) => chatRepo.startChat(scheduleID);

  @override
  Future<void> notifyChat(NotifyUserViewModel model) async {
    final chat = await chatRepo.findChatByID(model.chatID);

    if (chat != null) {
      switch (model.userType) {
        case NotificatioUserType.user:
          _notifyUser(chat.userDeviceToken?.tokens, model, chat);
          break;
        case NotificatioUserType.supplier:
        _notifyUser(chat.supplierDeviceToken?.tokens, model, chat);
          break;
        }
    }
  }

  void _notifyUser(
      List<String?>? tokens, NotifyUserViewModel model, Chat chat) {
    final payload = <String, dynamic>{
      'type': 'CHAT_MESSAGE',
      'chat': {
        'id': chat.id,
        'nome': chat.name,
        'fornecedor': {
          'nome': chat.supplier.name,
          'logo': chat.supplier.logo,
        },
      }
    };

    facade.sendMessage(
        devices: tokens ?? [],
        title: 'Nova Mensagem',
        body: model.message,
        payload: payload);
  }
  
  @override
  Future<List<Chat>> getChatsByUser(int user) => chatRepo.getChatsByUser(user);
  
  @override
  Future<List<Chat>> getChatsBySupplier(int supplier) => chatRepo.getChatsBySupplier(supplier);
}
