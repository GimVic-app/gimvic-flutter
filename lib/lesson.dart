import 'package:flutter/material.dart';
import 'package:gimvic_flutter/main.dart';

TextStyle numberTextStyle =
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300);

TextStyle lessonTextStyle =
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500);

TextStyle classroomTextStyle =
    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300);

TextStyle numberTextStyleNadomescanje = TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w400,
        color: dark ? Colors.greenAccent[400] : Colors.green[400]
    );

TextStyle lessonTextStyleNadomescanje = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    color: dark ? Colors.greenAccent[400] : Colors.green[400]
);

TextStyle classroomTextStyleNadomescanje = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: dark ? Colors.greenAccent[400] : Colors.green[400]
);

class Lesson extends StatelessWidget {
  final Map<String, dynamic> data;

  Lesson(this.data);

  @override
  Widget build(BuildContext context) {
    if (data['prosta_ura']) {
      return getFreeTimeCard();
    } else if (data['je_nadomescanje']) {
      return getSupLessionItem();
    } else {
      return getLessonItem();
    }
  }

  Widget getFreeTimeCard() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Row(
          children: <Widget>[
            Text(data['stevilka'].toString(), style: numberTextStyle),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('   -', style: lessonTextStyle))),
          ],
        ),
      ),
    );
  }

  Widget getLessonItem() {
    return Container(
        color: Colors.transparent,
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

  Widget getSupLessionItem() {
    return Container(
      child: _SupLessonItem(data),
    );
  }
}

class _SupLessonItem extends StatefulWidget {
  final Map<String, dynamic> data;

  _SupLessonItem(this.data);

  @override
  _SupLessonItemState createState() => _SupLessonItemState();
}

class _SupLessonItemState extends State<_SupLessonItem>
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
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: <Widget>[
                  Text(widget.data['stevilka'].toString(),
                      style: numberTextStyleNadomescanje),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(widget.data['predmet'],
                              style: lessonTextStyleNadomescanje))),
                  Text(widget.data['ucilnica'].toString(),
                      style: classroomTextStyleNadomescanje),
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
