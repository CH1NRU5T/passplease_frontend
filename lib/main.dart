// import 'package:cryptography/cryptography.dart';

// void main() async {
//   /*
//   RSAKeypair rsaKeypair = RSAKeypair.fromRandom();
//   String ansh = rsaKeypair.publicKey.encrypt('ansh');
//   print('ecfromdart: $ansh');
//   http.Response res =
//       await http.post(Uri.parse('https://jb657c4r-3000.inc1.devtunnels.ms/en'),
//           body: jsonEncode({
//             'key': rsaKeypair.publicKey.toString(),
//           }),
//           headers: {'Content-Type': 'application/json'});
//   String msg = jsonDecode(res.body)['e'];
//   print('ecfromnode: $msg');
//   String d = rsaKeypair.privateKey.decrypt(ansh);
//   */

//   final pbkdf2 = Pbkdf2(
//     macAlgorithm: Hmac.sha256(),
//     iterations: 10000, // 20k iterations
//     bits: 256, // 256 bits = 32 bytes output
//   );
//   SecretKey secretKey1 = await pbkdf2
//       .deriveKeyFromPassword(password: 'password', nonce: [1, 2, 3]);
//   secretKey1.extractBytes().then((value) {
//     print(value);
// StringBuffer sb = StringBuffer();
// for (var element in value) {
//   var val = element.toRadixString(16);
//   if (val.length == 1) {
//     sb.write('0');
//     sb.write(val);
//   } else {
//     sb.write(val);
//   }
// }
//     print(sb.toString() ==
//         '17836d0172c5de0fa60fbead4866922bcf9772c333624e49ccde11266151075d');
//   });
// }
import 'package:flutter/material.dart';
import 'package:passplease_frontend/features/auth/screens/auth_screen.dart';
import 'package:passplease_frontend/features/home/screens/home_screen.dart';
import 'package:passplease_frontend/providers/saved_password_provider.dart';
import 'package:passplease_frontend/providers/user_provider.dart';
import 'package:passplease_frontend/router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SavedPasswordProvider(),
        ),
      ],
      child: MaterialApp(
        onGenerateRoute: (settings) => generateRoute(settings),
        home: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.user == null) {
              return const AuthScreen();
            } else {
              return const HomeScreen();
            }
          },
        ),
      ),
    ),
  );
}


/**
 * H(email+masterpassword) 10000 -> vaultkey(v)
 * H(v+masterpassword) 5000 -> authkey(a)
 * 
 */