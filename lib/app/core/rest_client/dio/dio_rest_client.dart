import 'package:dio/dio.dart';
import 'package:projeto_cuidapet/app/core/helpers/constants.dart';
import 'package:projeto_cuidapet/app/core/helpers/environments.dart';
import 'package:projeto_cuidapet/app/core/local_storage/local_storage.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';
import 'package:projeto_cuidapet/app/core/rest_client/dio/interceptor/auth_interceptor.dart';
import 'package:projeto_cuidapet/app/core/rest_client/dio/interceptor/auth_refresh_token_interceptor.dart';
import 'package:projeto_cuidapet/app/core/rest_client/rest_client.dart';
import 'package:projeto_cuidapet/app/core/rest_client/rest_client_exception.dart';
import 'package:projeto_cuidapet/app/core/rest_client/rest_client_response.dart';
import 'package:projeto_cuidapet/app/modules/core_module/auth/auth_store.dart';

class DioRestClient implements RestClient {
  late final Dio _dio;

  final _defaultOptions = BaseOptions(
    baseUrl: Environments.param(Constants.ENV_BASE_URL_KEY) ?? '',
    connectTimeout: Duration(
      milliseconds: int.parse(
          Environments.param(Constants.REST_CLIENT_CONNECT_TIMEOUT) ?? '0'),
    ),
    receiveTimeout: Duration(
      milliseconds: int.parse(
          Environments.param(Constants.REST_CLIENT_RECEIVER_TIMEOUT) ?? '0'),
    ),
  );

  DioRestClient({
    required LocalStorage localStorage,
    required LocalSecureStorage localSecureStorage,
    required AppLogger log,
    required AuthStore authStore,
    BaseOptions? options,
  }) {
    _dio = Dio(options ?? _defaultOptions);
    _dio.interceptors.addAll([
      AuthInterceptor(localStorage: localStorage, authStore: authStore),
      AuthRefreshTokenInterceptor(
          authStore: authStore,
          localStorage: localStorage,
          secureStorage: localSecureStorage,
          restClient: this,
          log: log),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      )
    ]);
  }

  @override
  RestClient auth() {
    _defaultOptions.extra[Constants.REST_CLIENT_AUTH_REQUIRED_KEY] = true;
    return this;
  }

  @override
  Future<RestClientResponse<T>> delete<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> patch<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> post<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> put<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> request<T>(String path,
      {required String method,
      data,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          method: method,
        ),
      );
      return _dioResponseConverter(response);
    } on DioException catch (e) {
      _throwRestClientException(e);
    }
  }

  @override
  RestClient unAuth() {
    _defaultOptions.extra[Constants.REST_CLIENT_AUTH_REQUIRED_KEY] = false;
    return this;
  }

  RestClientResponse<T> _dioResponseConverter<T>(Response<dynamic> response) {
    return RestClientResponse<T>(
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage);
  }

  Never _throwRestClientException(DioException dioError) {
    final response = dioError.response;

    throw RestClientException(
      error: dioError.error,
      statusCode: response?.statusCode,
      message: response?.statusMessage,
      response: RestClientResponse(
        data: response?.data,
        statusCode: response?.statusCode,
        statusMessage: response?.statusMessage,
      ),
    );
  }
}
