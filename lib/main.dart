import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gimvic_flutter/main_page.dart';
import 'package:gimvic_flutter/settings.dart';

void main() async {
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(new MyApp());
}

bool dark = false;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gimvič',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: dark ? Brightness.dark : Brightness.light,
        accentColor: dark ? Colors.greenAccent[400] : null,
        backgroundColor: dark ? Colors.blueGrey[900] : Colors.grey[200]
      ),
      home: MainPage(),
    );
  }
}

