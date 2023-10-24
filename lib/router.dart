import 'package:flutter/material.dart';
import 'package:passplease_frontend/features/auth/screens/auth_screen.dart';
import 'package:passplease_frontend/features/home/screens/home_screen.dart';

Route generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );
    case AuthScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AuthScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );
  }
}
