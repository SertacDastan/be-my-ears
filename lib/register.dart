import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final dio = Dio();

  final String loginApiUrl = 'https://4843-92-45-192-191.ngrok-free.app/register';

  Future<Map<String, dynamic>> registerApi(String name, String email, String password) async {
    Map<String, String> map = {'name': name, 'email': email, 'password': password};
    final response = await dio.post(
      loginApiUrl,
      data: map,
      options: Options(
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
      ),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to Register');
    }
  }

  void register() {
    registerApi(nameController.text, emailController.text, passwordController.text).then((value) {
      print(value);
      if (value["message"] == 'Kayıt başarılı.') {
        Navigator.pushNamed(context, '/loginScreen');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Hata"),
                content: Text(value["message"]),
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
    }).catchError((error) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Hata"),
              content: const Text("Lütfen Bağlantılarınızı Kontrol Edin"),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 242, 241, 236),
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: 400,
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    Image.asset(
                      "lib/assets/logo.jpeg",
                    ),
                    // Text(
                    //   "Be My Ears",
                    //   style: TextStyle(color: Colors.orangeAccent, fontSize: 55, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                    // ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))), labelText: 'İsim', hintText: 'İsminizi Girin'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))), labelText: 'Email', hintText: 'Email Adresinizi Girin'),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))), labelText: 'Şifre', hintText: 'Şifrenizi Girin'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        minimumSize: const Size(60, 45),
                        padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 8),
                      ),
                      child: const Text("Kayıt Ol"),
                      onPressed: () {
                        register();
                      },
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
