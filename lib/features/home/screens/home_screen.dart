import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:passplease_frontend/constants/constants.dart';
import 'package:passplease_frontend/constants/widgets.dart';
import 'package:passplease_frontend/features/home/services/home_service.dart';
import 'package:passplease_frontend/models/saved_password.dart';
import 'package:passplease_frontend/providers/saved_password_provider.dart';
import 'package:passplease_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _passwordNameController;
  late TextEditingController _passwordUrlController;
  late TextEditingController _passwordController;
  late HomeService _homeService;
  @override
  void initState() {
    super.initState();
    _homeService = HomeService();
    _passwordNameController = TextEditingController();
    _passwordUrlController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordNameController.dispose();
    _passwordUrlController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void addPassword() {
    _homeService.addPassword(
        SavedPassword(
          name: _passwordNameController.text,
          url: _passwordUrlController.text,
          value: _passwordController.text,
          key: secretKeyToString(context.read<UserProvider>().user!.vaultKey!),
        ),
        context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return AlertDialog.adaptive(
                title: const Text('Add Password'),
                content: Column(
                  children: [
                    CustomTextFormField(
                      controller: _passwordNameController,
                      labelText: 'Name',
                    ),
                    CustomTextFormField(
                      controller: _passwordUrlController,
                      labelText: 'URL',
                    ),
                    CustomTextFormField(
                      controller: _passwordController,
                      labelText: 'Password',
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      addPassword();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<SavedPasswordProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.passwords.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      '${provider.passwords[index].decodePassword(secretKeyToString(context.read<UserProvider>().user!.vaultKey!), IV.fromBase64(provider.passwords[index].iv!))} ${provider.passwords[index].value}',
                    ),
                  ));
                },
                title: Text(provider.passwords[index].name),
                subtitle: Text(provider.passwords[index].url),
              );
            },
          );
        },
      ),
    );
  }
}
