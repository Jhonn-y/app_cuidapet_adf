import 'package:cuidapet_api/application/helpers/request_mapping.dart';

class NotifyUserViewModel extends RequestMapping {
  late int chatID;
  late String message;
  late NotificatioUserType userType;

  NotifyUserViewModel(super.dataRequest);

  @override
  void map() {
    chatID = data['chat'];
    message = data['message'];
    String notificatioTypeRq = data['to'];
    userType = notificatioTypeRq.toLowerCase() == 'u'
        ? NotificatioUserType.user
        : NotificatioUserType.supplier;
  }
}

enum NotificatioUserType {
  user,
  supplier,
}
