import 'package:projeto_cuidapet/app/core/exceptions/failure.dart';
import 'package:projeto_cuidapet/app/core/exceptions/user_exists_exception.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';
import 'package:projeto_cuidapet/app/core/rest_client/rest_client.dart';
import 'package:projeto_cuidapet/app/core/rest_client/rest_client_exception.dart';

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
}
