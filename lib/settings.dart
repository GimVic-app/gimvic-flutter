import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sharedPreferences;
Function updateAppTheme;

class SettingsView extends StatefulWidget {
  final List<Map<String, Object>> days;

  SettingsView(this.days);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  List<String> snackOptions, lunchOptions;
  bool darkTheme;

  @override
  void initState() {
    Map<String, Object> menu =
        widget.days[0]['jedilnik'] as Map<String, Object>;

    snackOptions = (menu['malica'] as Map<String, Object>).keys.toList();
    lunchOptions = (menu['kosilo'] as Map<String, Object>).keys.toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nastavitve'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Malica'),
            DropdownButton(
              items: snackOptions.map((String option) {
                return DropdownMenuItem<String>(
                  child: Text(option),
                  value: option,
                );
              }).toList(),
              value: sharedPreferences.getString('snack_type'),
              onChanged: (String selected) async {
                sharedPreferences.setString('snack_type', selected);
                setState(() {});
              },
            ),
          ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Kosilo'),
                DropdownButton(
                  items: lunchOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      child: Text(option),
                      value: option,
                    );
                  }).toList(),
                  value: sharedPreferences.getString('lunch_type'),
                  onChanged: (String selected) async {
                    sharedPreferences.setString('lunch_type', selected);
                    setState(() {});
                  },
                ),
              ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Temna tema'),
              Switch(
                  value: sharedPreferences.getBool('dark_theme'),
                  onChanged: (value) {
                    sharedPreferences.setBool('dark_theme', value);
                    updateAppTheme();
                    setState(() {});
                  },
                  activeColor: sharedPreferences.getBool('dark_theme')
                      ? Colors.greenAccent[400]
                      : Colors.green[400])
            ],
          )
        ],
      ),
    );
  }
}
