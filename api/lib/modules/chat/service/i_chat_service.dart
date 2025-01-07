import 'package:cuidapet_api/modules/chat/view_models/notify_user_view_model.dart';

abstract class IChatService {
  Future<int> startChat(int scheduleID);
  Future<void> notifyChat(NotifyUserViewModel model);
}