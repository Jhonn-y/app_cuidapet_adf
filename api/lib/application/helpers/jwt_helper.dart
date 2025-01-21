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

  static String generateJwt(int userID, int? supplierID){
    final claimSet = JwtClaim(
      issuer: 'cuidapet',
      subject: userID.toString(),
      expiry: DateTime.now().add(Duration(seconds: 20)),
      notBefore: DateTime.now(),
      issuedAt: DateTime.now(),
      otherClaims: <String, dynamic>{
        'supplier': supplierID
      },
      maxAge: const Duration(days: 1)
    );

    return 'Bearer ${issueJwtHS256(claimSet, _jwtSecret)}';
  }

  static String refreshToken(String accessToken){
    final claimSet = JwtClaim(
      issuer: accessToken,
      subject: 'RefreshToken',
      expiry: DateTime.now().add(Duration(days: 20)),
      notBefore: DateTime.now(),
      issuedAt: DateTime.now(),
      otherClaims: <String, dynamic>{},
    );
    return 'Bearer ${issueJwtHS256(claimSet, _jwtSecret)}';
  }
}
