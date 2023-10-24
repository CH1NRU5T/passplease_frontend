import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:passplease_frontend/api.dart';
import 'package:passplease_frontend/constants/constants.dart';
import 'package:passplease_frontend/constants/encrypt.dart';
import 'package:passplease_frontend/models/saved_password.dart';
import 'package:passplease_frontend/providers/saved_password_provider.dart';
import 'package:passplease_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomeService {
  Future<bool> addPassword(SavedPassword password, BuildContext context) async {
    (String?, dynamic) response =
        await Api.post('$BASE_URL/createSavedPassword', {
      'name': password.name,
      'url': password.url,
      'encryptedPassword': password.encodePassword(
        secretKeyToString(context.read<UserProvider>().user!.vaultKey!),
        IV.fromBase64(password.iv!),
      ),
      'iv': password.iv,
      'createdBy': context.read<UserProvider>().user!.id,
    });
    if (response.$1 == null) {
      if (context.mounted) {
        context.read<SavedPasswordProvider>().add(password);
      }
      return true;
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.$1.toString()),
          ),
        );
      }
      return false;
    }
  }
}
