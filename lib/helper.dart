import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'service.dart';
import 'dialog.dart';
import 'results.dart';

class helperClass {
  static double width = 600;

  static SlideTransition transBuilder(
      context, animation, secondaryAnimation, child) {
    const begin = Offset(0.3, 0.0);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end);
    final offsetAnimation = animation.drive(tween);
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}
