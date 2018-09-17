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

  List<Map<String, Object>> days;

  @override
  void initState() {
    controller = TabController(vsync: this, length: 5);
    super.initState();

    loadData();
  }

  void loadData() async {
    Map<String, Object> data = await getData();
    print(data);
    setState(() {
      days = (data['dnevi'] as List).cast<Map<String, Object>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [];

    for (int i = 0; i < _dayNames.length; i++) {
      tabs.add(SafeArea(child: DayView(days != null ? days[i] : null)));
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('GimVic'),
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
      body: TabBarView(controller: controller, children: tabs),
    );
  }
}
