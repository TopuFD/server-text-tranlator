import 'package:api_translator/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator_plus/translator_plus.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final Controller controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: GetBuilder<Controller>(
        builder: (controller) {
          if (controller.data.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: controller.data.length,
            itemBuilder: (context, index) {
              final item = controller.data[index];
              return ListTile(
                title: FutureBuilder<String>(
                  future: translateToBengali(item.title ?? 'No content'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Translating...');
                    } else if (snapshot.hasError) {
                      return const Text('Translation failed');
                    } else {
                      return Text(snapshot.data ?? 'No content');
                    }
                  },
                ),
                subtitle: FutureBuilder<String>(
                  future: translateToBengali(item.body ?? 'No content'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Translating...');
                    } else if (snapshot.hasError) {
                      return const Text('Translation failed');
                    } else {
                      return Text(snapshot.data ?? 'No content');
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<String> translateToBengali(String text) async {
    final translator = GoogleTranslator();
    try {
      var translation = await translator.translate(text, to: 'bn');
      return translation.text;
    } catch (e) {
      print(
          "====================================================Translation failed: $e");
      return "Translation failed";
    }
  }
}
