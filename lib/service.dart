import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

ServiceClass service = ServiceClass();

/*
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}*/

class ServiceClass {
  ServiceClass() {
    // HttpOverrides.global = MyHttpOverrides();
    print("test");
  }

  QuizClass quiz = QuizClass();

  String onlineUrl = "https://reeppi-quiz.netlify.app";
  String offlineUrl = "http://192.168.1.100:8888";

  fetchQuiz(String quizName) async {
    try {
      final response =
          await http.get(Uri.parse(onlineUrl + '/quiz?name=' + quizName));
      var d = jsonDecode(response.body);
      if (d.containsKey("error")) {
        throw (d["error"]);
      } else
        quiz.fromJson(d);
    } catch (error) {
      print("Error: $error");
      throw (error);
    }
  }
}

class QuizClass {
  String name = "";
  String title = "";
  String email = "";
  bool public = false;
  List<QuestionClass> questions = <QuestionClass>[];

  QuizClass();

  fromJson(Map<String, dynamic> json) {
    questions.clear();
    name = json["name"];
    title = json["title"];
    public = json["public"];
    email = json["email"];

    var qs = json['questions'];
    for (var e in qs) {
      var entry = QuestionClass();
      entry.text = e["text"];
      entry.correct = e["true"];
      entry.image = e["image"];
      entry.width = e["width"];
      entry.height = e["height"];
      entry.audio = e["audio"];
      entry.answer = e["answer"];
      for (var o in e["options"]) entry.options.add(o);
      questions.add(entry);
    }
    for (QuestionClass e in questions) {
      print(e.text);
    }
  }
}

class QuestionClass {
  QuestionClass();
  String text = "";
  List<String> options = [];
  int correct = 0;
  String image = "";
  int width = 0;
  int height = 0;
  String audio = "";
  int? answer = 0;
}
