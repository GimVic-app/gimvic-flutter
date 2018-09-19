import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gimvic_flutter/main_page.dart';
import 'package:gimvic_flutter/settings.dart';

void main() async {
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(GimVic());
}

class GimVic extends StatefulWidget {
  @override
  GimVicState createState() => GimVicState();
}

class GimVicState extends State<GimVic> {
  bool dark;

  @override
  void initState() {
    dark = sharedPreferences.getBool('dark_theme');
    updateAppTheme = updateTheme;

    if (dark == null) {
      dark = false;
      sharedPreferences.setBool('dark_theme', dark);
    }

    super.initState();
  }

  void updateTheme() {
    setState(() {
      dark = sharedPreferences.getBool('dark_theme');
    });
  }

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

