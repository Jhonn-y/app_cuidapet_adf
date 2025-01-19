import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_cuidapet/app/core/exceptions/failure.dart';
import 'package:projeto_cuidapet/app/core/exceptions/user_exists_exception.dart';
import 'package:projeto_cuidapet/app/core/exceptions/user_not_exists_exception.dart';
import 'package:projeto_cuidapet/app/core/helpers/constants.dart';
import 'package:projeto_cuidapet/app/core/local_storage/local_storage.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';
import 'package:projeto_cuidapet/app/model/social_login_type.dart';
import 'package:projeto_cuidapet/app/model/social_network_model.dart';
import 'package:projeto_cuidapet/app/repo/social/i_social_repo.dart';
import 'package:projeto_cuidapet/app/repo/user/i_user_repo.dart';

import './i_user_service.dart';

class UserService implements IUserService {
  final IUserRepo _userRepo;
  final AppLogger _log;
  final LocalStorage _localStorage;
  final LocalSecureStorage _secureStorage;
  final ISocialRepo _socialRepo;

  UserService(
      {required LocalSecureStorage secureStorage,
      required AppLogger log,
      required IUserRepo userRepo,
      required LocalStorage localStorage,
      required ISocialRepo socialRepo})
      : _userRepo = userRepo,
        _localStorage = localStorage,
        _secureStorage = secureStorage,
        _socialRepo = socialRepo,
        _log = log;

  @override
  Future<void> register(String email, String password) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;

      final userMethods = await firebaseAuth.fetchSignInMethodsForEmail(email);

      if (userMethods.isNotEmpty) {
        throw UserExistsException();
      }

      await _userRepo.register(email, password);
      final userRegisterCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userRegisterCredential.user?.sendEmailVerification();
    } on FirebaseException catch (e) {
      _log.error('Erro ao criar usuario no firebase', e);
      throw Failure(message: 'Erro ao criar usuario no firebase');
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;

      final loginMethods = await firebaseAuth.fetchSignInMethodsForEmail(email);

      if (loginMethods.isEmpty) {
        throw UserNotExistsException();
      }

      if (loginMethods.contains('password')) {
        final userCredential = await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);

        final userVerified = userCredential.user?.emailVerified ?? false;

        if (!userVerified) {
          userCredential.user?.sendEmailVerification();
          throw Failure(
              message:
                  'Email não verificado, olhe seu email ou caixa de spam para continuar.');
        }

        final accessToken = await _userRepo.login(email, password);
        await _saveAccessToken(accessToken);
        await _confirmLogin();
        await _getUserData();
      } else {
        throw Failure(
          message:
              'Login não pode ser feito com esse email e senha, tente com outro método para entrar!',
        );
      }
    } on FirebaseAuthException catch (e) {
      _log.error('Usuario ou senha invalidos', e);
      throw Failure(message: 'Usuario ou senha invalidos');
    }
  }

  Future<void> _saveAccessToken(String accessToken) => _localStorage
      .write<String>(Constants.LOCAL_STORAGE_ACCESS_TOKEN_KEY, accessToken);

  Future<void> _confirmLogin() async {
    final confirmloginModel = await _userRepo.confirmLogin();

    await _saveAccessToken(confirmloginModel.accessToken);
    await _localStorage.write(Constants.LOCAL_STORAGE_REFRESH_TOKEN_KEY,
        confirmloginModel.refreshToken);
  }

  Future<void> _getUserData() async {
    final userModel = await _userRepo.getUserLogged();
    await _localStorage.write<String>(
        Constants.LOCAL_STORAGE_USER_LOGGED_DATA_KEY, userModel.toJson());
  }

  @override
  Future<void> socialLogin(SocialLoginType loginType) async {
    try {
      final SocialNetworkModel socialModel;
      final AuthCredential authCredential;
      final firebaseAuth = FirebaseAuth.instance;

      switch (loginType) {
        case SocialLoginType.google:
          socialModel = await _socialRepo.googleLogin();
          authCredential = GoogleAuthProvider.credential(
            accessToken: socialModel.accessToken,
            idToken: socialModel.id,
          );
          break;
        case SocialLoginType.facebook:
          throw Failure(message: '');
          break;
      }

      final loginMethods =
          await firebaseAuth.fetchSignInMethodsForEmail(socialModel.email);

      final methodCheck = _getMethodSocialLoginType(loginType);
      if (loginMethods.isNotEmpty && !loginMethods.contains(methodCheck)) {
        throw Failure(
            message:
                'Login não pode ser feito com $methodCheck, tente com outro método para entrar!');
      }

      await firebaseAuth.signInWithCredential(authCredential);
      final accessToken = await _userRepo.loginSocial(socialModel);
      await _saveAccessToken(accessToken);
      await _confirmLogin();
      await _getUserData();
    } on FirebaseAuthException catch (e) {
      _log.error('Erro ao realizar login com $loginType');
      throw Failure(message: 'Erro ao realizar login');
    }
  }

  String _getMethodSocialLoginType(SocialLoginType loginType) {
    switch (loginType) {
      case SocialLoginType.google:
        return 'google.com';
      case SocialLoginType.facebook:
        return 'facebook.com';
    }
  }
}
