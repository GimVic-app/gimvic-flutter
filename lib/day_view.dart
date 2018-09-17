import 'package:flutter/material.dart';
import 'package:gimvic_flutter/menu.dart';
import 'package:gimvic_flutter/lesson.dart';

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

    Widget timetable = Column(
        children: (data['ure'] as List).map((data) => Lesson(data)).toList());

    Widget menu = Menu(data['jedilnik'] as Map<String, Object>);

    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [timetable, menu],
    );
  }
}
