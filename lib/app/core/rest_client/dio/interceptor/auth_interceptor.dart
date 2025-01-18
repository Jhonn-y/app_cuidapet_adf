import 'package:dio/dio.dart';
import 'package:projeto_cuidapet/app/core/helpers/constants.dart';
import 'package:projeto_cuidapet/app/core/local_storage/local_storage.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';
import 'package:projeto_cuidapet/app/modules/core_module/auth/auth_store.dart';

class AuthInterceptor extends Interceptor {
  final LocalStorage _localStorage;
  final AppLogger _log;
  final AuthStore _authStore;

  AuthInterceptor(
      {required AuthStore authStore,
      required LocalStorage localStorage,
      required AppLogger log})
      : _localStorage = localStorage,
        _authStore = authStore,
        _log = log;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final authRequired =
        options.extra[Constants.REST_CLIENT_AUTH_REQUIRED_KEY] ?? false;

    if (authRequired) {
      final accessToken = await _localStorage
          .read<String>(Constants.LOCAL_STORAGE_ACCESS_TOKEN_KEY);

      if (accessToken == null) {
        _authStore.logOut();
        return handler.reject(
          DioException(
              requestOptions: options,
              error: 'Expired Token',
              type: DioExceptionType.cancel),
        );
      }

      options.headers['Authorization'] = accessToken;
    } else {
      options.headers.remove('Authorization');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {}

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {}
}
