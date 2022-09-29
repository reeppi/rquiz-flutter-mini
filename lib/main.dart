import 'dart:math';

import 'package:flutter/material.dart';

import 'quiz.dart';
import 'service.dart';
import 'helper.dart';
import 'results.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const Main(title: 'TIETOVISA'),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key, required this.title});
  final String title;

  static Route createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const Main(title: "TIETOVISA"),
      transitionsBuilder: helperClass.transBuilder,
    );
  }

  @override
  State<Main> createState() => _Main();
}

class _Main extends State<Main> with TickerProviderStateMixin {
  @override
  late AnimationController controller;
  String errorMsg = "";

  initState() {
    super.initState();
    print("Main loaded");
    setState(() {
      errorMsg = "";
    });
    ctrlQuizName.text = "test";

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: false);
  }

  TextEditingController ctrlQuizName = TextEditingController();

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: helperClass.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextField(
                controller: ctrlQuizName,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Visan nimi',
                ),
                onChanged: (value) {
                  print(ctrlQuizName.text);
                },
              ),
              loading
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(2, 10, 2, 2),
                      child: CircularProgressIndicator(
                        value: controller.value,
                        semanticsLabel: 'Circular progress indicator',
                      ),
                    )
                  : SizedBox.shrink(),
              Text(errorMsg),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Avaa visa'),
        onPressed: () async {
          if (!loading) {
            try {
              loading = true;
              await service.fetchQuiz(ctrlQuizName.text);
              loading = false;
              errorMsg = "";
              Navigator.of(context).push(QuizWidgetClass.createRoute(0));
              //Navigator.of(context).push(Results.createRoute());
            } catch (err) {
              setState(() {
                errorMsg = "$err";
              });
              loading = false;
            }
          }
        },
        tooltip: '',
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
