import 'dart:convert';

import 'package:cryptography/cryptography.dart';

class User {
  String name;
  String email;
  String id;
  List<int>? vaultKey;
  SecretKey? token;
  User({
    required this.name,
    required this.email,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'id': id,
      // add token
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      email: map['email'] as String,
      id: map['_id'] as String,
      // add token
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
