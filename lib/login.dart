import 'package:be_my_ears/home.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Kullanıcı Adı', hintText: 'Kullanıcı Adınızı Girin'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Şifre', hintText: 'Şifrenizi Girin'),
                ),
              ),
              ElevatedButton(
                child: const Text("Login"),
                onPressed: () {
                  if (usernameController.text == 'admin' && passwordController.text == 'admin') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyHomePage()),
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Hatalı Kullanıcı Adı veya Şifre"),
                            content: const Text("Lütfen Kontrol Edin"),
                            actions: [
                              Center(
                                child: ElevatedButton(
                                  child: const Text("Tamam"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              )
                            ],
                          );
                        });
                  }
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
