import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class dialogClass {
  static Future<void> dialogBuilder(BuildContext context, String url) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                  color: Theme.of(context).dialogBackgroundColor,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                      child: Image.network(url, scale: 1)))),
        );
      },
    );
  }
}
