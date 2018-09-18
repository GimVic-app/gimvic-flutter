import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:after_layout/after_layout.dart';
import 'package:gimvic_flutter/api.dart';
import 'package:gimvic_flutter/day_view.dart';
import 'package:gimvic_flutter/settings.dart';

const _dayNames = ['Ponedeljek', 'Torek', 'Sreda', 'Četrtek', 'Petek'];

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin, AfterLayoutMixin<MainPage> {
  TabController controller;
  List<GlobalKey<RefreshIndicatorState>> refreshKeys;

  List<Map<String, Object>> days;
  bool error = false;

  @override
  void initState() {
    int weekday = new DateTime.now().weekday - 1;
    if (weekday > 4) weekday = 0;
    controller = TabController(vsync: this, length: 5, initialIndex: weekday);
    super.initState();

    refreshKeys = [];
    for (int i = 0; i < _dayNames.length; i++) {
      refreshKeys.add(GlobalKey<RefreshIndicatorState>());
    }

    loadData();
  }

  void loadData() async {
    error = false;

    for (GlobalKey<RefreshIndicatorState> key in refreshKeys) {
      key.currentState?.show();
    }

    Map<String, Object> data;
    try {
      data = await getData();
    } on DioError {
      setState(() {
        error = true;
      });
      return;
    }

    setState(() {
      days = (data['dnevi'] as List).cast<Map<String, Object>>();
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (days == null) {
      for (GlobalKey<RefreshIndicatorState> key in refreshKeys) {
        key.currentState?.show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [];

    for (int i = 0; i < _dayNames.length; i++) {
      tabs.add(SafeArea(
          child: DayView(
              days != null ? days[i] : null, loadData, refreshKeys[i], error)));
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('GimVič'),
        bottom: TabBar(
            controller: controller,
            isScrollable: true,
            tabs: _dayNames.map<Tab>((String day) {
              return Tab(
                text: day.toUpperCase(),
              );
            }).toList()),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                print('tle se mormo logoutat'); //TODO: logout (after login)
              }),
          new IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return SettingsView(days);
                  })
                );
              })
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: TabBarView(controller: controller, children: tabs),
    );
  }
}
