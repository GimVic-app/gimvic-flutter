import 'package:flutter/material.dart';
import 'package:gimvic_flutter/api.dart';
import 'package:gimvic_flutter/day_view.dart';

const _dayNames = ['Ponedeljek', 'Torek', 'Sreda', 'Četrtek', 'Petek'];

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {

  TabController controller;
  List<GlobalKey<RefreshIndicatorState>> refreshKeys;

  List<Map<String, Object>> days;

  @override
  void initState() {
    int weekday = new DateTime.now().weekday - 1;
    controller = TabController(vsync: this, length: 5, initialIndex: weekday);
    super.initState();

    refreshKeys = [];
    for (int i = 0; i < _dayNames.length; i++) {
      refreshKeys.add(GlobalKey<RefreshIndicatorState>());
    }

    loadData();
  }

  void loadData() async {
    for (GlobalKey<RefreshIndicatorState> key in refreshKeys) {
      key.currentState?.show();
    }

    Map<String, Object> data = await getData();
    setState(() {
      days = (data['dnevi'] as List).cast<Map<String, Object>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [];

    for (int i = 0; i < _dayNames.length; i++) {
      tabs.add(SafeArea(
          child: DayView(
              days != null ? days[i] : null,
              loadData,
              refreshKeys[i]
          )
      ));
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
                print('tle odpremo settingse'); //TODO: settings
              })
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: TabBarView(controller: controller, children: tabs),
    );
  }
}
