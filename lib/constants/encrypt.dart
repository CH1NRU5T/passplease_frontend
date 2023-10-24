import 'package:cryptography/cryptography.dart';
import 'package:passplease_frontend/constants/constants.dart';

Future<List<int>> makeVaultKey(String email, String password) async {
  Pbkdf2 pbkdf2 =
      Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: 100000, bits: 256);

  SecretKey vaultKey = await pbkdf2.deriveKeyFromPassword(
    password: '$email$password',
    nonce: generateSalt(email),
  );
  return vaultKey.extractBytes();
}

Future<List<int>> makeAuthKey(List<int> vaultKey, String password) async {
  Pbkdf2 pbkdf2 =
      Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: 5000, bits: 256);
  SecretKey authKey = await pbkdf2.deriveKeyFromPassword(
    password: '${secretKeyToString(vaultKey)}$password',
    nonce: generateSalt(password),
  );
  return authKey.extractBytes();
}

List<int> generateSalt(String email) {
  List<String> separatedEmail = email.split('@');
  List<int> salt = [];
  for (var i = 0; i < separatedEmail.first.length; i++) {
    salt.add(separatedEmail.first.codeUnitAt(i));
  }
  return salt;
}
