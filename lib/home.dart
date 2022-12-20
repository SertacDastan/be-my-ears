import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Be My Ears"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  const Text(
                    'Merhaba. Nasılsınız...',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
              Image.asset("lib/assets/download.png"),
              ElevatedButton(onPressed: () {}, child: Icon(Icons.mic)),
            ],
          ),
        ),
      ),
    );
  }
}
