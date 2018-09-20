import 'package:flutter/material.dart';
import 'package:gimvic_flutter/settings.dart';

TextStyle numberTextStyle =
TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300);

TextStyle lessonTextStyle =
TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500);

TextStyle classroomTextStyle =
TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300);

bool dark;

TextStyle numberTextStyleNadomescanje;
TextStyle lessonTextStyleNadomescanje;
TextStyle classroomTextStyleNadomescanje;
TextStyle substitutionOriginalSubjectTextStyle;
TextStyle teacherTextStyle;
TextStyle noteTitleTextStyle;
TextStyle noteTextStyle;

class Lesson extends StatelessWidget {
  final Map<String, dynamic> data;

  Lesson(this.data);

  @override
  Widget build(BuildContext context) {
    dark = sharedPreferences.getBool('dark_theme');

    numberTextStyleNadomescanje = TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w400,
        color: dark ? Colors.greenAccent[400] : Colors.green[400]);
    lessonTextStyleNadomescanje = TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        color: dark ? Colors.greenAccent[400] : Colors.green[400]);
    classroomTextStyleNadomescanje = TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: dark ? Colors.greenAccent[400] : Colors.green[400]);
    substitutionOriginalSubjectTextStyle = TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w400,
        color: dark ? Colors.grey[700] : Colors.grey[300],
        decoration: TextDecoration.lineThrough);
    teacherTextStyle = TextStyle(
        fontSize: 13.0,
        fontWeight: dark ? FontWeight.w400 : FontWeight.w300,
        color: dark ? Colors.grey[500] : null
    );
    noteTitleTextStyle = TextStyle(
        fontSize: 14.0,
        fontWeight:
        FontWeight.w400,
        color: dark ? Colors.grey[400] : null
    );
    noteTextStyle = TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w300,
        color: dark ? Colors.grey[500] : null
    );

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
              Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(data['predmet'], style: lessonTextStyle)),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 12.0, right: 16.0),
                      child: Text((data['ucitelji'].join(', ')),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: teacherTextStyle))),
              Container(
                width: 32.0,
                child: Text(data['ucilnica'].toString(),
                    style: classroomTextStyle, textAlign: TextAlign.right),
              )
            ],
          ),
        ));
  }

  Widget getSupLessionItem() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(data['stevilka'].toString(),
                    style: numberTextStyleNadomescanje),
                Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(left: 12.0),
                                    child: Text(data['prosta_ura'] ? '-' : data['predmet'],
                                        style: lessonTextStyleNadomescanje)),
                                Padding(
                                    padding: EdgeInsets.only(left: 6.0),
                                    child: Text(data['original']['predmet'] ?? '',
                                        style:
                                        substitutionOriginalSubjectTextStyle)),
                              ],
                            ),
                            Expanded(child: Row(
                              children: <Widget>[
                                Expanded(child: Padding(
                                    padding:
                                    EdgeInsets.only(left: 12.0, right: 16.0),
                                    child: Text((data['prosta_ura'] ? '-' : data['ucitelji'].join(', ')),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style: teacherTextStyle))),
                                Container(
                                  width: 32.0,
                                  child: Text(data['prosta_ura'] ? '-' : data['ucilnica'].toString(),
                                      style: classroomTextStyleNadomescanje,
                                      textAlign: TextAlign.right),
                                )
                              ],
                            ))
                          ],
                        ),
                        data['opomba'] != null && data['opomba'] != ''
                            ? Padding(
                          padding: EdgeInsets.only(top: 4.0, left: 12.0),
                          child: Row(
                            children: <Widget>[
                              Text('Opomba:', style: noteTitleTextStyle),
                              Padding(padding: EdgeInsets.only(left: 6.0)),
                              Text(
                                data['opomba'],
                                style: noteTextStyle,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        )
                            : Container()
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
