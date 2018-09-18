import 'package:flutter/material.dart';

const TextStyle numberTextStyle =
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300);

const TextStyle lessonTextStyle =
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500);

const TextStyle classroomTextStyle =
    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300);

const TextStyle freeTextStyle =
    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300);

const TextStyle numberTextStyleSuplenca =
TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300, color: Colors.white);

const TextStyle lessonTextStyleSuplenca =
TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.white70);

const TextStyle classroomTextStyleSuplenca =
TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300, color: Colors.white);

class Lesson extends StatelessWidget {
  final Map<String, dynamic> data;

  Lesson(this.data);

  @override
  Widget build(BuildContext context) {
    if (data['prosta_ura']) {
      return getFreeTimeCard(Colors.grey[300]);
    } else if (data['je_nadomescanje']) {
      return getSupLessionCard(Colors.green[400]);
    } else {
      return getLessonCard();
    }
  }

  Card getFreeTimeCard(Color color) {
    return Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Row(
            children: <Widget>[
              Text('prosta ura', style: freeTextStyle)
            ],
          ),
        ));
  }

  Card getLessonCard() {
    return Card(
        elevation: 0.0,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
    return InkWell(
        onTap: _handleTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Text(widget.data['stevilka'].toString(),
                      style: numberTextStyleSuplenca),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(widget.data['predmet'],
                              style: lessonTextStyleSuplenca))),
                  Text(widget.data['ucilnica'].toString(),
                      style: classroomTextStyleSuplenca),
                ],
              ),
            ),
            ClipRect(
              child: Align(
                heightFactor: _easeInAnimation.value,
                child: child,
              ),
            ),
          ],
        ));
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
