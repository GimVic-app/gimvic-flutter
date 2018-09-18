import 'package:flutter/material.dart';
import 'package:gimvic_flutter/menu.dart';
import 'package:gimvic_flutter/lesson.dart';

class DayView extends StatelessWidget {
  final Map<String, Object> data;
  final Function onRefresh;
  final GlobalKey<RefreshIndicatorState> indicatorKey;

  DayView(this.data, this.onRefresh, this.indicatorKey);

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return RefreshIndicator(
        key: indicatorKey,
        onRefresh: () async => await onRefresh(),
        child: Container(),
      );
    }

    Widget timetable = Column(
        children: (data['ure'] as List).map((data) => Lesson(data)).toList());

    Widget menu = Menu(data['jedilnik'] as Map<String, Object>);

    return RefreshIndicator(
      key: indicatorKey,
      onRefresh: () async => await onRefresh(),
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: [timetable, menu],
      )
    );
  }
}
