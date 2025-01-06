// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/chat/data/i_chat_repo.dart';
import 'package:injectable/injectable.dart';

import './i_chat_service.dart';

@LazySingleton(as: IChatService)
class ChatService implements IChatService {
  IChatRepo chatRepo;
  ILogger log;

  ChatService({
    required this.chatRepo,
    required this.log,
  });
  
  @override
  Future<int> startChat(int scheduleID) => chatRepo.startChat(scheduleID);
}
