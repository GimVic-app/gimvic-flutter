import 'package:flutter/material.dart';

const TextStyle numberTextStyle =
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300);

const TextStyle lessonTextStyle =
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500);

const TextStyle classroomTextStyle =
    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300);

class Lesson extends StatelessWidget {
  final Map<String, dynamic> data;

  Lesson(this.data);

  @override
  Widget build(BuildContext context) {
    if (data['prosta_ura']) {
      return getFreeTimeCard(Theme.of(context).disabledColor);
    } else if (data['je_nadomescanje']) {
      return getSupLessionCard(Theme.of(context).accentColor);
    } else {
      return getLessonCard();
    }
  }

  Card getFreeTimeCard(Color color) {
    return Card(
        color: color,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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

  Card getSupLessionCard(Color color) {
    return Card(
      color: color,
      child: _SupLessonCard(data),
    );
  }
}

class _SupLessonCard extends StatefulWidget {
  final Map<String, dynamic> data;

  _SupLessonCard(this.data);

  @override
  _SupLessonCardState createState() => _SupLessonCardState();
}

class _SupLessonCardState extends State<_SupLessonCard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _easeInAnimation;

  bool expanded = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _easeInAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      expanded = !expanded;
      if (expanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((Null value) {
          setState(() {});
        });
      }
    });
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: _handleTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Text(widget.data['stevilka'].toString(),
                      style: numberTextStyle),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(widget.data['predmet'],
                              style: lessonTextStyle))),
                  Text(widget.data['ucilnica'].toString(),
                      style: classroomTextStyle),
                ],
              ),
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _easeInAnimation.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget getAdditionalDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(children: <Widget>[
        Text(
          'Prvotno:',
          style: TextStyle(fontSize: 16.0),
        ),
        Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.data['original']['predmet'],
                  style: lessonTextStyle,
                ))),
        Text(
          widget.data['original']['ucilnica'],
          style: classroomTextStyle,
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !expanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : getAdditionalDetails(),
    );
  }
}
