import 'package:flutter/material.dart';

class DayView extends StatelessWidget {
  final Map<String, Object> data;

  DayView(this.data);

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    List<Widget> elements = [];

    for (Map<String, Object> lesson in data['ure']) {
      if (lesson['prosta_ura']) {
        elements.add(new Card(
            color: Colors.black12,
            child: Row(
              children: <Widget>[Text(lesson['stevilka'].toString())],
            )));
        continue;
      }

      elements.add(Card(
        color: lesson['je_nadomescanje'] == true
            ? Theme.of(context).accentColor
            : null,
        child: Row(
          children: <Widget>[
            Text(lesson['stevilka'].toString()),
            Text(lesson['predmet']),
            Column(
              children: <Widget>[
                Text((lesson['ucitelji'] as List).cast<String>().join(', ')),
                Text(lesson['ucilnica'].toString())
              ],
            )
          ],
        ),
      ));
    }

    elements.add(Container(
      height: 32.0,
    ));
    elements.add(Card(
      child: Column(
        children: <Widget>[
          Text('Malica'),
//          Text((((data['jedilnik'] as Map<String, Object>)['malica']
//                  as Map<String, Object>)['navadna'] as List<String>)
//              .join('\n'))
        ],
      ),
    ));

    return ListView(
      padding: EdgeInsets.all(8.0),
      children: elements,
    );
  }
}
