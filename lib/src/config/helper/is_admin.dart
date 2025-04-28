import 'package:agend_app/src/infrastructure/services/auth_services/auth_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<bool> isAdmin() async {
  final token = await AuthStorage.getToken();
  if (token == null) return false;

  final decoded = JwtDecoder.decode(token);
  return decoded['is_admin'] == true;
}
