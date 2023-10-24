import 'package:flutter/material.dart';
import 'package:passplease_frontend/constants/extensions.dart';
import 'package:passplease_frontend/constants/widgets.dart';
import 'package:passplease_frontend/features/auth/services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static const String routeName = '/auth';
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  late AuthService _authService;
  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  void signup(BuildContext content) {
    _authService.createUser(_nameController.text, _emailController.text,
        _passwordController.text, context);
  }

  void login(BuildContext content) {
    _authService.login(_nameController.text, _emailController.text,
        _passwordController.text, context);
  }

  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            child: Placeholder(),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLogin)
                    CustomTextFormField(
                      labelText: 'Name',
                      controller: _nameController,
                    ),
                  10.height,
                  CustomTextFormField(
                    labelText: 'Email',
                    controller: _emailController,
                  ),
                  10.height,
                  CustomTextFormField(
                    labelText: 'Password',
                    controller: _passwordController,
                  ),
                  10.height,
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            isLogin ? login(context) : signup(context);
                          },
                          child: Text(isLogin ? 'Login' : 'Sign up'),
                        ),
                      ),
                      10.width,
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(isLogin ? 'Sign up' : 'Login'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
