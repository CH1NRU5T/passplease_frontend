import 'package:flutter/material.dart';
import 'package:passplease_frontend/api.dart';
import 'package:passplease_frontend/constants/constants.dart';
import 'package:passplease_frontend/constants/encrypt.dart';
import 'package:passplease_frontend/models/user.dart';
import 'package:passplease_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AuthService {
  void createUser(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    List<int> vaultKey = await makeVaultKey(email, password);
    List<int> authKey = await makeAuthKey(vaultKey, password);
    (String?, dynamic) response = await Api.post(
      '$BASE_URL/createUser',
      {
        'name': name,
        'email': email,
        'password': secretKeyToString(authKey),
      },
    );
    if (response.$1 == null) {
      User user = User.fromMap(response.$2);
      if (context.mounted) {
        context.read<UserProvider>().setUser(user);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.$1.toString()),
          ),
        );
      }
    }
  }

  void login(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    List<int> vaultKey = await makeVaultKey(email, password);
    List<int> authKey = await makeAuthKey(vaultKey, password);
    (String?, dynamic) response = await Api.post(
      '$BASE_URL/login',
      {
        'email': email,
        'password': secretKeyToString(authKey),
      },
    );
    if (response.$1 == null) {
      User user = User.fromMap(response.$2);
      user.vaultKey = vaultKey;
      if (context.mounted) {
        UserProvider provider = context.read<UserProvider>();
        provider.setUser(user);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.$1.toString()),
          ),
        );
      }
    }
  }
}
