import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gimvic_flutter/settings.dart';
import 'package:gimvic_flutter/api.dart';

class User {
  static bool isLoggedIn() {
    String token = sharedPreferences.getString('token');

    if (token == null) return false;
    return true;
  }

  static void logout() {
    sharedPreferences.remove('token');
  }

  static Future<bool> login(String username, String password) async {
    print(username);
    print(password);

    Map<String, Object> response = await loginUser(username, password);

    if (response['success'] == null || !response['success']) {
      return false;
    }
    String token = response['token'];
    if (token == null) {
      return false;
    }

    sharedPreferences.setString('token', token);
    return true;
  }
}

class LoginView extends StatefulWidget {
  LoginView();

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorMessage;

  bool loggingIn = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> login() async {
    setState(() {
      loggingIn = true;
    });

    String username = _usernameController.text;
    String password = _passwordController.text;

    _usernameController.clear();
    _passwordController.clear();

    await User.login(username, password);

    setState(() {
      loggingIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget error;

    if (errorMessage != '' && errorMessage != null) {
      error = Text(errorMessage);
    } else {
      error = Container();
    }

    return Scaffold(
        backgroundColor: Colors.green,
        body: Theme(
          data: Theme.of(context).copyWith(
            brightness: Brightness.light,
            accentColor: Colors.white,
            primaryColor: Colors.white
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Image.asset(
                  'images/logo.png',
                  width: 100.0,
              )),
              _addPaddingAndMaxWidth(TextField(
                controller: _usernameController,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Uporabniško ime',
                    hintStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white.withAlpha(120)),
                    border: UnderlineInputBorder()
                ),
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white),
                onChanged: (text) => setState(() {}),
                autocorrect: false,
                cursorColor: Colors.white,
                textCapitalization: TextCapitalization.none,
              )),
              _addPaddingAndMaxWidth(TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                    hintText: 'Geslo',
                    hintStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white.withAlpha(120)),
                ),
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white),
                obscureText: true,
                cursorColor: Colors.white,
                onChanged: (text) => setState(() {}),
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
              )),
              error,
              _addPaddingAndMaxWidth(FlatButton(
                  disabledTextColor: Colors.white.withAlpha(120),
                  textColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  onPressed: _usernameController.text != '' &&
                          _passwordController.text != ''
                      ? login
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Prijava'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 16.0,
                          ))
                    ],
                  )))
            ],
          ),
        ));
  }
}

Widget _addPaddingAndMaxWidth(Widget child) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300.0),
      child: child,
    ),
  );
}
