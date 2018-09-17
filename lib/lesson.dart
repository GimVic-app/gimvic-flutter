import 'package:flutter/material.dart';

const TextStyle numberTextStyle =
    TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300);

const TextStyle lessonTextStyle = TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500);

const TextStyle classroomTextStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300);

class Lesson extends StatelessWidget {
  final Map<String, dynamic> data;

  Lesson(this.data);

  @override
  Widget build(BuildContext context) {
    if (data['prosta_ura']) {
      return getFreeTimeCard(Theme.of(context).disabledColor);
    } else if (data['je_nadomescanje']) {
      return getSupLessonCard(Theme.of(context).accentColor);
    } else {
      return getLessonCard();
    }
  }

  Card getFreeTimeCard(Color color) {
    return Card(
        color: color,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            children: <Widget>[
              Text(data['stevilka'].toString(), style: numberTextStyle)
            ],
          ),
        ));
  }

  Card getLessonCard() {
    return Card(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        children: <Widget>[
          Text(data['stevilka'].toString(), style: numberTextStyle),
          Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(data['predmet'], style: lessonTextStyle))),
          Text(data['ucilnica'].toString(), style: classroomTextStyle),
        ],
      ),
    ));
  }

  Card getSupLessonCard(Color color) {
    return Card(
      color: color,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            children: <Widget>[
              Text(data['stevilka'].toString(), style: numberTextStyle),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(data['predmet'], style: lessonTextStyle))),
              Text(data['ucilnica'].toString(), style: classroomTextStyle),
            ],
          ),
        ));
  }
}
