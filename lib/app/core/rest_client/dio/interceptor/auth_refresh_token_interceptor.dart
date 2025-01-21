import 'package:dio/dio.dart';
import 'package:projeto_cuidapet/app/core/exceptions/expired_token_exception.dart';
import 'package:projeto_cuidapet/app/core/helpers/constants.dart';
import 'package:projeto_cuidapet/app/core/local_storage/local_storage.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';
import 'package:projeto_cuidapet/app/core/rest_client/rest_client.dart';
import 'package:projeto_cuidapet/app/modules/core_module/auth/auth_store.dart';

class AuthRefreshTokenInterceptor extends Interceptor {
  final AuthStore _authStore;
  final LocalStorage _localStorage;
  final LocalSecureStorage _secureStorage;
  final RestClient _restClient;
  final AppLogger _log;

  AuthRefreshTokenInterceptor(
      {required AuthStore authStore,
      required LocalStorage localStorage,
      required LocalSecureStorage secureStorage,
      required RestClient restClient,
      required AppLogger log})
      : _authStore = authStore,
        _localStorage = localStorage,
        _secureStorage = secureStorage,
        _restClient = restClient,
        _log = log;

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    try {
      final respStatusCode = err.response?.statusCode ?? 0;
      final reqPath = err.requestOptions.path;

      if (respStatusCode == 403 || respStatusCode == 401) {
        if (reqPath != '/auth/refresh') {
          final authRequired = err.requestOptions
                  .extra[Constants.REST_CLIENT_AUTH_REQUIRED_KEY] ??
              false;
          if (authRequired) {
            _log.info('################# Refreshing token #################');
            await _refreshToken(err);
            await _retryRequest(err, handler);
          } else {
            throw err;
          }
        } else {
          throw err;
        }
      } else {
        throw err;
      }
    } on DioException catch (e) {
      handler.next(e);
    } on ExpiredTokenException {
      _authStore.logOut();
      handler.next(err);
    } catch (e) {
      _log.error('Erro rest client', e);
      handler.next(err);
    }
  }

  Future<void> _refreshToken(DioException err) async {
    final refreshToken =
        await _secureStorage.read(Constants.LOCAL_STORAGE_REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      throw ExpiredTokenException();
    }

    final resultRefresh = await _restClient.auth().put('/auth/refresh', data: {
      'refresh_token': refreshToken,
    });

    await _localStorage.write<String>(Constants.LOCAL_STORAGE_ACCESS_TOKEN_KEY,
        resultRefresh.data['access_token']);

    await _secureStorage.write(Constants.LOCAL_STORAGE_REFRESH_TOKEN_KEY,
        resultRefresh.data['refresh_token']);
  }

  Future<void> _retryRequest(
      DioException err, ErrorInterceptorHandler handler) async {
    _log.info('################# Retry request #################');

    final requestOptions = err.requestOptions;

    final result = await _restClient.request(
      requestOptions.path,
      method: requestOptions.method,
      data: requestOptions.data,
      headers: requestOptions.headers.cast<String, String>(),
      queryParameters: requestOptions.queryParameters,
    );

    handler.resolve(Response(
        requestOptions: requestOptions,
        data: result.data,
        statusCode: result.statusCode,
        statusMessage: result.statusMessage));
  }
}
