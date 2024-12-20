import 'package:dotenv/dotenv.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtHelper {
  JwtHelper._();

  static final dotenv = DotEnv(includePlatformEnvironment: true);

  static Future<void> initialize() async {
    dotenv.load();
  }

  static String get _jwtSecret {
    return dotenv['JWT_SECRET'] ?? dotenv['TOKEN_SECRET']!;
  }

  static JwtClaim getClaims(String token) {
    return verifyJwtHS256Signature(token, _jwtSecret);
  }
}
