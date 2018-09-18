import 'package:flutter/material.dart';

const String snackType = 'navadna';
const String lunchType = 'navadno';

class Menu extends StatelessWidget {
  final Map<String, Object> menu;

  Menu(this.menu);

  @override
  Widget build(BuildContext context) {
    List<String> snack =
        ((menu['malica'] as Map<String, Object>)[snackType] as List)
            .cast<String>();
    List<String> lunch =
        ((menu['kosilo'] as Map<String, Object>)[lunchType] as List)
            .cast<String>();

    return Column(children: [
      Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: MenuEntry(
            'Malica - $snackType',
            snack.join('\n'),
          )),
      Padding(
        padding: EdgeInsets.only(top: 4.0),
      ),
      Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: MenuEntry(
            'Kosilo - $lunchType',
            lunch.join('\n'),
          )
      )
    ]);
  }
}

class MenuEntry extends StatelessWidget {
  final String title, content;

  MenuEntry(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Text(title,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
            ),
            Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0),
            )
          ]),
        ));
  }
}
