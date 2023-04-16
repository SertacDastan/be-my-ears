import 'package:be_my_ears/login.dart';
import 'package:be_my_ears/register.dart';
import 'package:be_my_ears/userModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserModel()),
      ],
      child: MaterialApp(
          title: 'Be My Ears',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          routes: <String, WidgetBuilder>{
            '/registerScreen': (context) => const RegisterScreen(),
            '/loginScreen': (context) => const LoginScreen(),
          },
          home: const LoginScreen()),
    );
  }
}
