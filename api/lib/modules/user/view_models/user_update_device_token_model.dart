// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cuidapet_api/application/helpers/request_mapping.dart';
import 'package:cuidapet_api/modules/user/view_models/platform_enum.dart';

class UserUpdateDeviceTokenModel extends RequestMapping {
  
  int userID;
  late String token;
  late PlatformEnum platform;
  
  UserUpdateDeviceTokenModel({
    required this.userID,
    required String dataRequest}
  ) : super(dataRequest);

  @override
  void map() {
    token = data['token'];
    platform = (data['platform'].toLowerCase() == 'ios' ? PlatformEnum.ios : PlatformEnum.android);
  }
  
}
