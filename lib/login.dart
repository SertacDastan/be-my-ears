import 'package:be_my_ears/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final dio = Dio();

  final String loginApiUrl = 'https://4843-92-45-192-191.ngrok-free.app/login';

  Future<Map<String, dynamic>> loginApi(String email, String password) async {
    Map<String, String> map = {'email': email, 'password': password};
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
      throw Exception('Failed to Log-in');
    }
  }

  void login() {
    loginApi(emailController.text, passwordController.text).then((value) {
      print(value);
      if (value["message"] == "Giriş başarılı.") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
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
                    height: 330,
                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                      Image.asset(
                        "lib/assets/logo.jpeg",
                      ),
                      // Text(
                      //   "Be My Ears",
                      //   style: TextStyle(color: Colors.orangeAccent, fontSize: 55, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                      // ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))), labelText: 'Email', hintText: 'Email Adresinizi Girin'),
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))), labelText: 'Şifre', hintText: 'Şifrenizi Girin'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              minimumSize: const Size(60, 45),
                              padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 8),
                            ),
                            child: const Text("Giriş Yap"),
                            onPressed: () {
                              login();
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              minimumSize: const Size(60, 45),
                              padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 8),
                            ),
                            child: const Text("Kayıt ol"),
                            onPressed: () {
                              Navigator.pushNamed(context, '/registerScreen');
                            },
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
