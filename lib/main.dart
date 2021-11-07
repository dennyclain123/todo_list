import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/constants.dart';
import 'package:todo_list_app/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: DoubleBackToCloseApp(
          child: Home(),
          snackBar: const SnackBar(
            content: Text('Tap back again to exit'),
          ),
        ),
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: bg_color,
        primaryColor: fg_color,
        primarySwatch: Colors.indigo
      ),
    );
  }
}

