import 'package:cuidapet_api/entities/chat.dart';

abstract class IChatRepo {

  Future<int> startChat(int scheduleID);
  Future<Chat?> findChatByID(int chatID);
  Future<List<Chat>> getChatsByUser(int user);

}