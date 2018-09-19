import 'package:flutter/material.dart';
import 'package:gimvic_flutter/settings.dart';

class Menu extends StatelessWidget {
  final Map<String, Object> menu;
  final bool dark = sharedPreferences.getBool('dark_theme');

  Menu(this.menu);

  @override
  Widget build(BuildContext context) {
    String snackType = sharedPreferences.getString('snack_type');
    String lunchType = sharedPreferences.getString('lunch_type');

    if (snackType == null) {
      snackType = (menu['malica'] as Map<String, Object>).keys.first;
    }
    if (lunchType == null) {
      lunchType = (menu['kosilo'] as Map<String, Object>).keys.first;
    }

    List<String> snack =
        ((menu['malica'] as Map<String, Object>)[snackType] as List)
            .cast<String>();
    List<String> lunch =
        ((menu['kosilo'] as Map<String, Object>)[lunchType] as List)
            .cast<String>();

    return Card(
      elevation: dark ? 0.0 : null,
      color: dark ? Colors.transparent : null,
      child: Column(children: [
        MenuEntry(
          'Malica',
          snack.join('\n'),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4.0),
        ),
        Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: MenuEntry(
              'Kosilo',
              lunch.join('\n'),
            )
        ),
      ]),
    );
  }
}

class MenuEntry extends StatelessWidget {
  final bool dark = sharedPreferences.getBool('dark_theme');
  final String title, content;

  MenuEntry(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: EdgeInsets.only(bottom: 4.0, top: 4.0),
              child: Text(title,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300)),
            ),
            Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.1,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: dark ? Colors.grey[400] : Colors.grey[800]),
            )
          ]),
        ));
  }
}
