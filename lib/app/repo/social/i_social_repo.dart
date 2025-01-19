import 'package:projeto_cuidapet/app/model/social_network_model.dart';

abstract class ISocialRepo {

  Future<SocialNetworkModel> googleLogin();
  Future<SocialNetworkModel> facebookLogin();

}