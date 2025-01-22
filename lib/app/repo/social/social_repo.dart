import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:projeto_cuidapet/app/core/exceptions/failure.dart';
import 'package:projeto_cuidapet/app/model/social_network_model.dart';

import './i_social_repo.dart';

class SocialRepo implements ISocialRepo {
  @override
  Future<SocialNetworkModel> facebookLogin() async {
    final facebookAuth = FacebookAuth.instance;
    final result = await facebookAuth.login();

    switch (result.status) {
      case LoginStatus.success:
        final userData = await facebookAuth.getUserData();
        return SocialNetworkModel(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          type: 'Facebook',
          avatar: userData['picture']['data']['url'],
          accessToken: result.accessToken?.token ?? '',
        );
      case LoginStatus.cancelled:
        throw Failure(message: 'Login cancelado');
      case LoginStatus.failed:
      case LoginStatus.operationInProgress:
        throw Failure(message: result.message);
    }
  }

  @override
  Future<SocialNetworkModel> googleLogin() async {
    try {
      final googleSingIn = await GoogleSignIn();

      if (await googleSingIn.isSignedIn()) {
        await googleSingIn.disconnect();
      }

      final googleUser = await googleSingIn.signIn();
      final googleAuth = await googleUser?.authentication;

      if (googleAuth != null && googleUser != null) {
        return SocialNetworkModel(
            id: googleAuth.idToken ?? '',
            name: googleUser.displayName ?? '',
            email: googleUser.email,
            type: 'Google',
            accessToken: googleAuth.accessToken ?? '');
      } else {
        throw Failure(message: 'Não foi possível realizar login com o Google');
      }
    } catch (e) {
      throw Failure(message: 'Erro ao realizar login com o Google');
    }
  }
}
