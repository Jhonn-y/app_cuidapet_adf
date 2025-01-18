import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:projeto_cuidapet/app/core/exceptions/failure.dart';
import 'package:projeto_cuidapet/app/core/exceptions/user_exists_exception.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';
import 'package:projeto_cuidapet/app/core/rest_client/rest_client.dart';
import 'package:projeto_cuidapet/app/core/rest_client/rest_client_exception.dart';
import 'package:projeto_cuidapet/app/model/confirm_login_model.dart';

import './i_user_repo.dart';

class UserRepo implements IUserRepo {
  final RestClient _restClient;
  final AppLogger _log;

  UserRepo({required RestClient restClient, required AppLogger log})
      : _restClient = restClient,
        _log = log;

  @override
  Future<void> register(String email, String password) async {
    try {
      await _restClient.unAuth().post('/auth/register/', data: {
        'email': email,
        'password': password,
      });
    } on RestClientException catch (e) {
      if (e.statusCode == 400 &&
          e.response.data['message'].contains('Usuario já cadastrado')) {
        _log.error(e.error, e);
        throw UserExistsException();
      }
      _log.error('Erro ao cadastrar usuario', e);
      throw Failure(message: 'Erro ao cadastrar usuario');
    }
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      final result = await _restClient.unAuth().post(
        '/auth/',
        data: {
          'login': email,
          'password': password,
          'social_login': false,
          'supplier_user': false
        },
      );

      return result.data['access_token'];
    } on RestClientException catch (e) {
      if (e.statusCode == 403) {
        throw Failure(
            message:
                'Usuario inconsistente no sistema, entre em contato com o suporte!!');
      }
      _log.error('Erro ao realizar login', e);
      throw Failure(
          message: 'Erro ao realizar login, tente novamente mais tarde');
    }
  }

  @override
  Future<ConfirmLoginModel> confirmLogin() async {
    try {
      final deviceToken = await FirebaseMessaging.instance.getToken();

      final result = await _restClient.auth().patch('/auth/confirm/', data: {
        'ios_token': Platform.isIOS ? deviceToken : null,
        'android_token': Platform.isAndroid ? deviceToken : null,
      });

      return ConfirmLoginModel.fromJson(result.data);
    } on RestClientException catch (e) {
      _log.error('Erro ao confirmar login', e);
      throw Failure(message: 'Erro ao confirmar login');
    }
  }
}
