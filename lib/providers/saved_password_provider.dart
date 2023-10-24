import 'package:flutter/material.dart';
import 'package:passplease_frontend/models/saved_password.dart';

class SavedPasswordProvider extends ChangeNotifier {
  final List<SavedPassword> _passwords = [];
  List<SavedPassword> get passwords => _passwords;
  void add(SavedPassword password) {
    _passwords.add(password);
    notifyListeners();
  }
}
