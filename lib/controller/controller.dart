import 'dart:convert';

import 'package:api_translator/model/model.dart';
import 'package:get/get.dart';
import 'package:translator_plus/translator_plus.dart';
import 'package:http/http.dart' as http;

class Controller extends GetxController {
  final translator = GoogleTranslator();
  Model modelData = Model();
  List data = [];
  Future<Model> getData() async {
    try {
      final response = await http
          .get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body) as List;
        data = body.map((item) => Model.fromJson(item)).toList();
        update();

        print(
            "===================================================${response.statusCode.toString()}");
      } else {
        return modelData;
      }
    } catch (e) {
      print(
          "===================================================${e.toString()}");
    }
    return modelData;
  }

  @override
  void onInit() {
    super.onInit();
    getData();
  }
}
