import 'package:flutter/material.dart';
import 'package:gimvic_flutter/menu.dart';
import 'package:gimvic_flutter/lesson.dart';
import 'package:gimvic_flutter/settings.dart';

class DayView extends StatelessWidget {
  final Map<String, Object> data;
  final Function onRefresh;
  final GlobalKey<RefreshIndicatorState> indicatorKey;
  final bool error;

  DayView(this.data, this.onRefresh, this.indicatorKey, this.error);

  @override
  Widget build(BuildContext context) {
    bool dark = sharedPreferences.getBool('dark_theme');

    if (data == null || error) {
      return RefreshIndicator(
        key: indicatorKey,
        onRefresh: () async => await onRefresh(),
        child: error
            ? ListView(physics: AlwaysScrollableScrollPhysics(), children: [
                Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: Center(
                      child: Text('Ni internetne povezave.')
                  )),
                FlatButton(
                  child: Text('Poskusi znova'.toUpperCase()),
                  onPressed: onRefresh,
                )
              ])
            : ListView(
                physics: AlwaysScrollableScrollPhysics(),
              ),
      );
    }

    Widget timetable = Card(
      color: dark ? Colors.grey[900] : null,
      elevation: dark ? 0.0 : null,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
            children:
                (data['ure'] as List).map((data) => Lesson(data)).toList()
        ),
      ),
    );

    Widget menu = Menu(data['jedilnik'] as Map<String, Object>);

    return RefreshIndicator(
        key: indicatorKey,
        onRefresh: () async => await onRefresh(),
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(8.0),
          children: [
            timetable,
            menu,
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            )
          ],
        ));
  }
}
