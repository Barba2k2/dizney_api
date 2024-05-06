import 'package:dotenv/dotenv.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtHelper {
  JwtHelper._();

  static final String _jwtScret = env['JWT_SECRET'] ?? env['jwtSecret']!;

  static JwtClaim getClaims(String token) {
    return verifyJwtHS256Signature(token, _jwtScret);
  }
}
