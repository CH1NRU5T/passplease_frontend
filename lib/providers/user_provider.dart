import 'package:flutter/material.dart';
import 'package:passplease_frontend/models/user.dart';

class UserProvider extends ChangeNotifier {
  User? user;
  void setUser(User user) {
    this.user = user;
    notifyListeners();
  }

  set vaultKey(List<int> vaultKey) {
    this.vaultKey = vaultKey;
    // notifyListeners();
  }
}
