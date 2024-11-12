import 'package:flutter/material.dart';

const textinputdecoration = InputDecoration(
    labelStyle: TextStyle(color: Colors.black),
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
    errorBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)));
void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextscreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplacement(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showsnackbar(context, message, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.orange,
    duration: Duration(seconds: 2),
    action: SnackBarAction(label: "OK", onPressed: () {}),
  ));
}
