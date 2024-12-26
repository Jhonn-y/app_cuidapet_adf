import 'dart:convert';

import 'package:cuidapet_api/application/helpers/jwt_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/application/middlewares/middlewares.dart';
import 'package:cuidapet_api/application/middlewares/security/security_skip_url.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/shelf.dart';

class SecurityMiddleware extends Middlewares {
  final ILogger log;
  final List<SecuritySkipUrl> skipUrl = [
    SecuritySkipUrl(url: '/auth/register', method: 'POST')
    
  ];

  SecurityMiddleware(this.log);

  @override
  Future<Response> execute(Request request) async {
    try {
    if (skipUrl.contains(
        SecuritySkipUrl(url: '/${request.url.path}', method: request.method))) {
      return innerHandler(request);
    }

    final authHeader = request.headers['Authorization'];

    if (authHeader == null) {
      throw JwtException.invalidToken;
    }

    final authHeaderContent = authHeader.split(' ');

    if (authHeaderContent[0] != 'Bearer') {
      throw JwtException.invalidToken;
    }

      final token = authHeaderContent[1];

      JwtHelper.initialize();
      final clains = JwtHelper.getClaims(token);
      if (request.url.path != 'auth/refresh') {
        clains.validate();
      }

      final clainsMap = clains.toJson();

      final userID = clainsMap['sub'];
      final supplierID = clainsMap['supplier'];

      if (userID == null) {
        throw JwtException.invalidToken;
      }

      final securityHeaders = {
        'user': userID,
        'acess-token': token,
        'supplier': supplierID,
      };

      return innerHandler(request.change(headers: securityHeaders));
    } on JwtException catch (e) {
      log.error('Error validating JWT token: $e');
      return Response.forbidden(jsonEncode({}));
    } on Exception catch (e) {
      log.error('Error: $e');
      return Response.forbidden(jsonEncode({}));
    }
  }
}
