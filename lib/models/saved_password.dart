// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:encrypt/encrypt.dart';

class SavedPassword {
  String name;
  String url;
  String value;
  String? iv;
  String? key;
  SavedPassword({
    required this.name,
    required this.url,
    required this.value,
    // required this.iv,
    this.key,
  }) {
    value = encodePassword(key!, IV.fromLength(16));
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'url': url,
      'value': value,
      'iv': iv,
    };
  }

  factory SavedPassword.fromMap(Map<String, dynamic> map) {
    return SavedPassword(
      name: map['name'] as String,
      url: map['url'] as String,
      value: map['value'] as String,
      // iv: map['iv'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedPassword.fromJson(String source) =>
      SavedPassword.fromMap(json.decode(source) as Map<String, dynamic>);

  String encodePassword(String key, IV iv) {
    this.iv = iv.base64;
    var encryptionKey = Key.fromBase16(key);
    final encrypter = Encrypter(AES(encryptionKey));
    final encrypted1 = encrypter.encrypt(value, iv: iv);
    print(this);
    return encrypted1.base64;
  }

  String decodePassword(String key, IV iv) {
    var encryptionKey = Key.fromBase16(key);
    final decrypter = Encrypter(AES(encryptionKey));
    final decrypted1 = decrypter.decrypt64(value, iv: iv);
    return decrypted1;
  }

  @override
  String toString() {
    return 'SavedPassword(name: $name, url: $url, value: $value, iv: $iv, key: $key)';
  }
}
