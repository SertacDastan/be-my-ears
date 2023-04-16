import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _hasSpeech = false;
  bool isEnabled = false;
  final String _currentLocaleId = 'tr-TR';
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String finalWord = '';
  final bool _logEvents = true;

  final String apiUrl = 'https://4843-92-45-192-191.ngrok-free.app/lemmatize';

  final SpeechToText speech = SpeechToText();

  final dio = Dio();

  @override
  void initState() {
    initSpeechState();
    super.initState();
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent('Received error status: $error, listening: ${speech.isListening}');
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    _logEvent('Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = status;
    });
  }

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      print('$eventTime $eventDescription');
    }
  }

  Future<void> initSpeechState() async {
    _logEvent('Initialize');

    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: false,
      );
      if (!mounted) return;

      setState(() {
        _hasSpeech = hasSpeech;
      });
    } catch (e) {
      setState(() {
        _hasSpeech = false;
      });
    }
  }

  void resultListener(SpeechRecognitionResult result) {
    _logEvent('Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    setState(() {
      lastWords = result.recognizedWords;
      finalWord = result.recognizedWords.split(' ').last;
    });
  }

  void startListening() {
    _logEvent('start listening');
    lastWords = '';
    lastError = '';
    speech.listen(
      onResult: resultListener,
      pauseFor: const Duration(seconds: 10),
      partialResults: true,
      localeId: _currentLocaleId,
      cancelOnError: false,
      listenMode: ListenMode.deviceDefault,
    );
    setState(() {});
  }

  void stopListening() {
    _logEvent('stop');
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  Widget showSign() {
    return FutureBuilder<String>(
      future: lemmatizeText(finalWord.toLowerCase()),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Failed to lemmatize text');
        } else {
          String lemmatizedText = snapshot.data!;
          return Image.asset(
            "lib/assets/gestures/$lemmatizedText.gif",
          );
        }
      },
    );
  }

  Future<String> lemmatizeText(String text) async {
    Map<String, String> map = {'text': text};
    final response = await dio.post(
      apiUrl,
      data: map,
      options: Options(
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
      ),
    );
    if (response.statusCode == 200) {
      return response.data[0][1][0];
    } else {
      throw Exception('Failed to lemmatize text');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Be My Ears"),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(40)),
                    height: 200,
                    padding: const EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            !isEnabled ? "Konuşmaya başlamak için butona basın..." : lastWords,
                            style: const TextStyle(fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (lastWords != '' && isEnabled) showSign(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isEnabled ? Colors.orange : Colors.orange.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        minimumSize: const Size(60, 60),
                        padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 8),
                      ),
                      onPressed: () {
                        isEnabled = !isEnabled;
                        if (isEnabled) {
                          startListening();
                        } else {
                          stopListening();
                        }
                      },
                      child: const Icon(Icons.mic)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
