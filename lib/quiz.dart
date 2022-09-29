import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'service.dart';
import 'dialog.dart';
import 'results.dart';
import 'helper.dart';

class QuizWidgetClass extends StatefulWidget {
  const QuizWidgetClass({
    super.key,
    required this.qIndex,
    required this.title,
  });
  final String title;
  final int qIndex;

  static Route createRoute(int index) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => QuizWidgetClass(
        title: "Kysymys " + (index + 1).toString() + ".",
        qIndex: index,
      ),
      transitionsBuilder: helperClass.transBuilder,
    );
  }

  @override
  State<QuizWidgetClass> createState() => _QuizWidgetClass();
}

class _QuizWidgetClass extends State<QuizWidgetClass> {
  String imageUrl = "";
  String audioUrl = "";

  final player = AudioPlayer();

  bool isPlaying = false;
  bool isLoaded = false;

  Duration? duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  initState() {
    super.initState();
    print("quiz page loaded");
    imageUrl =
        "https://eu2.contabostorage.com/cab6b4ec7ee045779d63f412f885dfe6:tietovisa/" +
            service.quiz.name +
            "/images/" +
            service.quiz.questions[widget.qIndex].image;

    audioUrl =
        "https://eu2.contabostorage.com/cab6b4ec7ee045779d63f412f885dfe6:tietovisa/" +
            service.quiz.name +
            "/audio/" +
            service.quiz.questions[widget.qIndex].audio;
    print(audioUrl);

    player.onDurationChanged.listen((event) {
      setState(() {
        print("total");
        print(event.inMilliseconds);
        isPlaying = true;
        duration = event;
      });
    });
    player.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });

    player.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        print("completed");
      });
    });
  }

  @override
  void dispose() {
    //   audioPlayer.dispose();
    super.dispose();
  }

  void updateState() {
    setState(() {});
  }

  List<Widget> _createOptions() {
    if (service.quiz.questions.isEmpty) {
      return List<Widget>.generate(1, (index) => SizedBox.shrink());
    }
    return List<Widget>.generate(
        service.quiz.questions[widget.qIndex].options.length, (int index) {
      return OptionClass(
        updateState: updateState,
        index: index,
        qIndex: widget.qIndex,
        refIndex: service.quiz.questions[widget.qIndex].options[index],
      );
    });
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              service.quiz.questions.isNotEmpty
                  ? Text(service.quiz.questions[widget.qIndex].text,
                      style: Theme.of(context).textTheme.bodyMedium)
                  : SizedBox.shrink(),
              service.quiz.questions[widget.qIndex].audio != ""
                  ? Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          child: IconButton(
                            iconSize: 20,
                            onPressed: () async {
                              if (isPlaying) {
                                player.pause();
                                setState(() {
                                  isPlaying = false;
                                });
                              } else {
                                setState(() {
                                  isPlaying = true;
                                });
                                player.play(UrlSource(audioUrl));
                                print(audioUrl);
                                setState(() {});
                                isLoaded = true;
                                print("player play");
                              }
                            },
                            icon:
                                Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                          ),
                        ),
                        Expanded(
                          child: duration!.inMilliseconds.toInt() > 0
                              ? Slider(
                                  min: 0,
                                  max: duration != null
                                      ? duration!.inMilliseconds.toDouble()
                                      : 0,
                                  value: min(position.inMilliseconds.toDouble(),
                                      duration!.inMilliseconds.toDouble()),
                                  onChanged: (value) async {},
                                )
                              : SizedBox.shrink(),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              Row(children: [
                Expanded(
                    child: Column(
                  children: _createOptions(),
                )),
                InkWell(
                  onTap: () {
                    dialogClass.dialogBuilder(context, imageUrl);
                    print("aa");
                  },
                  child: service.quiz.questions[widget.qIndex].image != ""
                      ? Image.network(imageUrl, scale: 2)
                      : SizedBox.shrink(),
                )
              ]),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: widget.qIndex == service.quiz.questions.length - 1
            ? const Text('Vastaukset')
            : const Text("Seuraava"),
        onPressed: () {
          if (widget.qIndex < service.quiz.questions.length - 1) {
            Navigator.of(context)
                .push(QuizWidgetClass.createRoute(widget.qIndex + 1));
          } else {
            Navigator.of(context).push(Results.createRoute());
          }
        },
        tooltip: '',
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

class OptionClass extends StatefulWidget {
  const OptionClass({
    super.key,
    required this.index,
    required this.refIndex,
    required this.qIndex,
    required this.updateState,
  });
  final int index;
  final String refIndex;
  final int qIndex;
  final Function updateState;
  @override
  State<OptionClass> createState() => _OptionClass();
}

class _OptionClass extends State<OptionClass> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      selected: service.quiz.questions[widget.qIndex].answer == widget.index
          ? true
          : false,
      selectedTileColor: Colors.blue[100],
      title: Text(
          String.fromCharCode(widget.index + 65) + ") " + widget.refIndex,
          style: Theme.of(context).textTheme.bodyMedium),
      onTap: () {
        service.quiz.questions[widget.qIndex].answer = widget.index;
        widget.updateState();
      },
    ));
  }
}
