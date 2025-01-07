import 'package:cuidapet_api/entities/chat.dart';
import 'package:cuidapet_api/modules/chat/view_models/notify_user_view_model.dart';

abstract class IChatService {
  Future<int> startChat(int scheduleID);
  Future<void> notifyChat(NotifyUserViewModel model);
  Future<List<Chat>> getChatsByUser(int user);
  Future<List<Chat>> getChatsBySupplier(int supplier);
}