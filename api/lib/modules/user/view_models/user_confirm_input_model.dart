// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cuidapet_api/application/exeptions/request_validation_exception.dart';
import 'package:cuidapet_api/application/helpers/request_mapping.dart';

class UserConfirmInputModel extends RequestMapping {
  int userID;
  String accessToken;
  String? iosDeviceToken;
  String? androidDeviceToken;
  UserConfirmInputModel(
      {required this.userID, required this.accessToken, required String data})
      : super(data);

  @override
  void map() {
    iosDeviceToken = data['ios_token'];
    androidDeviceToken = data['android_token'];
  }

  void validateRequest(){
    final errors = <String, String>{};

    if (iosDeviceToken == null && androidDeviceToken == null) {
      errors['ios or android token'] = 'required';
    }

    if (errors.isNotEmpty) {
      throw RequestValidationException(errors);
    }
  }
}
