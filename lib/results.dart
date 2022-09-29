import 'package:flutter/material.dart';

import 'quiz.dart';
import 'service.dart';
import 'main.dart';
import 'helper.dart';

class Results extends StatefulWidget {
  const Results({super.key, required this.title});
  final String title;

  static Route createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const Results(title: "Vastaukset"),
      transitionsBuilder: helperClass.transBuilder,
    );
  }

  @override
  State<Results> createState() => _Results();
}

class _Results extends State<Results> {
  int correct = 0;

  @override
  initState() {
    super.initState();
    print("results loaded");
    correct = 0;
    for (var q in service.quiz.questions) {
      if (q.answer == q.correct) correct += 1;
    }
    setState(() {});
  }

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Oikein :" +
                    correct.toString() +
                    "/" +
                    service.quiz.questions.length.toString(),
                style: Theme.of(context).textTheme.bodyLarge),
            service.quiz.questions.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: service.quiz.questions.length,
                    itemBuilder: (context, index) {
                      return ResultEntry(
                          index: index,
                          question: service.quiz.questions[index]);
                    })
                : SizedBox.shrink()
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Etusivulle'),
        onPressed: () async {
          Navigator.of(context).popUntil((route) => route.isFirst);
          // Navigator.of(context).push(Main.createRoute());
        },
        tooltip: '',
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

class ResultEntry extends StatefulWidget {
  const ResultEntry({super.key, required this.question, required this.index});
  final QuestionClass question;
  final int index;
  @override
  State<ResultEntry> createState() => _ResultEntry();
}

class _ResultEntry extends State<ResultEntry> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 2),
              child: Text((widget.index + 1).toString() +
                  ". " +
                  widget.question.text))),
      ListView.builder(
          shrinkWrap: true,
          itemCount: widget.question.options.length,
          itemBuilder: (context, index) {
            if (widget.question.answer == index &&
                widget.question.answer == widget.question.correct) {
              return Container(
                  color: Colors.lightGreen,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 2, 2, 0),
                      child: Text(widget.question.options[index])));
            }

            if (widget.question.answer == index &&
                widget.question.answer != widget.question.correct) {
              return Container(
                  color: Colors.redAccent,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 2, 2, 0),
                      child: Text(widget.question.options[index])));
            }
            if (widget.question.correct == index) {
              return Container(
                  color: Colors.yellowAccent,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 2, 2, 0),
                      child: Text(widget.question.options[index])));
            }
            return SizedBox.shrink();
          })
    ]);
  }
}
