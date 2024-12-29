// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cuidapet_api/application/helpers/request_mapping.dart';

class UpdateUrlAvatarModel extends RequestMapping {

  int userID;
  late String urlAvatar;


  UpdateUrlAvatarModel({
    required this.userID,
    required String dataRequest,
    }) : super(dataRequest);

  @override
  void map() {
    urlAvatar = data['url_avatar'];
  }
  
}
