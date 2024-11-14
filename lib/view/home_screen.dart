// import 'package:api_translator/controller/controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:translator_plus/translator_plus.dart';

// class HomeScreen extends StatelessWidget {
//   HomeScreen({super.key});
//   final Controller controller = Get.put(Controller());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home Screen"),
//       ),
//       body: GetBuilder<Controller>(
//         builder: (controller) {
//           if (controller.data.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           return ListView.builder(
//             itemCount: controller.data.length,
//             itemBuilder: (context, index) {
//               final item = controller.data[index];
//               return ListTile(
//                 title: FutureBuilder<String>(
//                   future: translateToBengali(item.title ?? 'No content'),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Text('Translating...');
//                     } else if (snapshot.hasError) {
//                       return const Text('Translation failed');
//                     } else {
//                       return Text(snapshot.data ?? 'No content');
//                     }
//                   },
//                 ),
//                 subtitle: FutureBuilder<String>(
//                   future: translateToBengali(item.body ?? 'No content'),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Text('Translating...');
//                     } else if (snapshot.hasError) {
//                       return const Text('Translation failed');
//                     } else {
//                       return Text(snapshot.data ?? 'No content');
//                     }
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Future<String> translateToBengali(String text) async {
//     final translator = GoogleTranslator();
//     try {
//       var translation = await translator.translate(text, to: 'bn');
//       return translation.text;
//     } catch (e) {
//       print(
//           "====================================================Translation failed: $e");
//       return "Translation failed";
//     }
//   }
// }import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  Timer? _silenceTimer;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    // Initialize speech-to-text and update state based on the result
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    if (_speechEnabled) {
      await _speechToText.listen(onResult: _onSpeechResult);
      setState(() {});
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    // Reset the silence timer whenever speech is detected
    _resetSilenceTimer();
  }

  void _resetSilenceTimer() {
    if (_silenceTimer != null && _silenceTimer!.isActive) {
      _silenceTimer!.cancel();
    }

    // Start a new timer that will stop listening after 3 seconds of silence
    _silenceTimer = Timer(Duration(seconds: 3), _stopListening);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Text("me: $_lastWords"),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  // If listening is active show the recognized words
                  _speechToText.isListening
                      ? '$_lastWords'
                      // If listening isn't active but could be tell the user
                      // how to start it, otherwise indicate that speech
                      // recognition is not yet ready or not supported on
                      // the target device
                      : _speechEnabled
                          ? 'Tap the microphone to start listening...'
                          : 'Speech not available',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_speechEnabled) {
            if (_speechToText.isNotListening) {
              _startListening();
            } else {
              _stopListening();
            }
          } else {
            // Optionally show a message if speech is not enabled
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Speech recognition is not enabled")),
            );
          }
        },
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
