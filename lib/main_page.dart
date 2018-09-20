import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:after_layout/after_layout.dart';
import 'package:gimvic_flutter/api.dart';
import 'package:gimvic_flutter/day_view.dart';
import 'package:gimvic_flutter/settings.dart';
import 'package:gimvic_flutter/login.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin, AfterLayoutMixin<MainPage> {
  TabController controller;
  List<GlobalKey<RefreshIndicatorState>> refreshKeys;
  List<List<String>> _dayNames = [
    ['Ponedeljek'],
    ['Torek'],
    ['Sreda'],
    ['Četrtek'],
    ['Petek']
  ];

  List<Map<String, Object>> days;
  bool error = false;
  bool loading = false;

  void loadData() async {
    if (loading) {
      while (loading) {
        await Future.delayed(Duration(milliseconds: 50));
        refreshKeys[controller.index].currentState?.show();
      }
      return;
    }

    error = false;
    loading = true;

    // force controller to show up.
    // Current state could be null for some reason
    refreshKeys[controller.index].currentState?.show();
    Future.delayed(Duration(milliseconds: 200)).then((_) {
      if (loading) refreshKeys[controller.index].currentState?.show();
    });
    Future.delayed(Duration(milliseconds: 400)).then((_) {
      if (loading) refreshKeys[controller.index].currentState?.show();
    });

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

    // not authorized
    if (data['dnevi'] == null) {
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
  void initState() {
    int weekday = new DateTime.now().weekday - 1;
    // show the next day in the afternoon
    if (DateTime.now().hour > 16 && DateTime.now().weekday != 5) weekday++;
    // handle weekends
    if (weekday > 4) weekday = 0;
    // set default tab
    controller = TabController(vsync: this, length: 5, initialIndex: weekday);

    // init dates (on weekend, show next week)
    DateTime day = DateTime.now();
    if (DateTime.now().weekday <= 5) {
      day = day.subtract(Duration(days: new DateTime.now().weekday - 1));
    } else {
      day = day.add(Duration(days: 8 - DateTime.now().weekday));
    }

    // fill dates for each day
    for (int i = 0; i < 5; i++) {
      _dayNames[i].add('${day.day.toString()}. ${day.month.toString()}.');
      day = day.add(Duration(days: 1));
    }

    super.initState();

    refreshKeys = [];
    for (int i = 0; i < _dayNames.length; i++) {
      refreshKeys.add(GlobalKey<RefreshIndicatorState>());
    }

    controller.addListener(() {
      if (loading) {
        // show refresh on new tab
        int index = controller.index;
        refreshKeys[index].currentState?.show();
      }
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (!User.isLoggedIn()) {
      openLoginPage();
      return;
    }

    if (days == null) {
      loadData();
      refreshKeys[controller.index].currentState?.show();
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
            height: 32.0),
        bottom: TabBar(
            controller: controller,
            isScrollable: true,
            tabs: _dayNames.map<Tab>((List<String> day) {
              return Tab(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(day[0].toUpperCase(),
                        softWrap: false, overflow: TextOverflow.fade),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Text(day[1],
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 13.0)),
                    )
                  ],
                ),
              );
            }).toList()),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // cannot show settings if data is not already loaded
                // (need to get menu data)
                if (days == null) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Ni internetne povezave'),
                          content: Text(
                              'Izbira jedilnika ni mogoča brez internetne povezave'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('V redu'.toUpperCase()),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                  return;
                }

                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return SettingsView(days, openLoginPage);
                }));
              })
        ],
      ),
      body: TabBarView(controller: controller, children: tabs),
    );
  }

  void openLoginPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LoginView();
    })).then((_) {
      if (User.isLoggedIn()) {
        loadData();
      } else {
        SystemNavigator.pop();
      }
    });
  }
}
