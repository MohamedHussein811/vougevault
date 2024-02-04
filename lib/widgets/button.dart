import 'package:flutter/material.dart';

Widget btn({String text = "", required VoidCallback? event})
  => MaterialButton(
    onPressed: event,
    color: Colors.blue,
    child: Text(text, style: TextStyle(color: Colors.white, fontSize: 30)),
  );






