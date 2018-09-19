import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:after_layout/after_layout.dart';
import 'package:gimvic_flutter/api.dart';
import 'package:gimvic_flutter/day_view.dart';
import 'package:gimvic_flutter/settings.dart';
import 'package:gimvic_flutter/login.dart';

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
  bool loading = false;

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
    if (loading) {
      while (loading) await Future.delayed(Duration(milliseconds: 50));
      return;
    }
    error = false;
    loading = true;

    for (GlobalKey<RefreshIndicatorState> key in refreshKeys) {
      key.currentState?.show();
    }

    Map<String, Object> data;
    try {
      data = await getData();
    } on DioError {
      setState(() {
        error = true;
        loading = false;
      });
      return;
    }

    loading = false;
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
    bool dark = sharedPreferences.getBool('dark_theme');
    List<Widget> tabs = [];

    for (int i = 0; i < _dayNames.length; i++) {
      tabs.add(SafeArea(
          child: DayView(
              days != null ? days[i] : null, loadData, refreshKeys[i], error)));
    }

    return new Scaffold(
      backgroundColor: dark ? Colors.grey[900] : null,
      appBar: new AppBar(
        backgroundColor: dark ? Colors.black : Colors.green,
        title: Image.asset(
            dark ? 'images/gimvic_green.png' : 'images/gimvic.png',
            height: 32.0
        ),
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
                print('tle se mormo logoutat');  // TODO: logout (after login)

                //TODO: za zdele to odpre login page
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return LoginView();
                    })
                );
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
      body: TabBarView(controller: controller, children: tabs),
    );
  }
}
