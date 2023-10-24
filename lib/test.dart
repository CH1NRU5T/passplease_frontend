import 'package:encrypt/encrypt.dart';

void main() {
  encodePassword(
      '86af87a7d45a6e88bb5226e1f3f179cf39466607c216deda98b4e360741c0a48');
}

String encodePassword(String key) {
  var encryptionKey = Key.fromBase16(key);
  final encrypter = Encrypter(AES(encryptionKey));
  final iv = IV.fromLength(16);
  final encrypted1 = encrypter.encrypt('FacebookPassword', iv: iv);
  return encrypted1.base64;
}
