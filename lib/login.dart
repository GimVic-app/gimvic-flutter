import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gimvic_flutter/settings.dart';
import 'package:gimvic_flutter/api.dart';

TextStyle _hintStyle = TextStyle(
    fontSize: 16.0,
    color: Colors.white.withAlpha(120));

const TextStyle _inputStyle = TextStyle(
    fontSize: 16.0,
    color: Colors.white);

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
  final FocusNode passwordFocusNode = FocusNode();
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

    _passwordController.clear();

    bool success = await User.login(username, password);
    if (success) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      errorMessage = 'Prijava ni bila uspešna';
      loggingIn = false;
    });
    FocusScope.of(context).requestFocus(passwordFocusNode);

  }

  @override
  Widget build(BuildContext context) {
    Widget error, submitButton;

    if (errorMessage != '' && errorMessage != null && !loggingIn) {
      error = _addPaddingAndMaxWidth(
          Text(
            errorMessage,
            style: TextStyle(fontSize: 16.0),
          ));
    } else {
      error = Container();
    }

    if (!loggingIn) {
      submitButton = FlatButton(
          disabledTextColor: Colors.white.withAlpha(120),
          textColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
          ));
    } else {
      submitButton = CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white));
    }

    submitButton = _addPaddingAndMaxWidth(submitButton);

    return Scaffold(
        backgroundColor: Colors.green,
        body: Theme(
          data: ThemeData(
            cursorColor: Colors.white,
            brightness: Brightness.dark,
            accentColor: Colors.white,
          ),
          child: ListView(children: [Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 64.0, 16.0, 32.0),
                  child: Image.asset(
                  'images/logo.png',
                  width: 100.0,
              )),
              _addPaddingAndMaxWidth(TextField(
                controller: _usernameController,
                autofocus: true,
                onSubmitted: (String username) {
                  FocusScope.of(context).requestFocus(passwordFocusNode);
                },
                decoration: InputDecoration(
                    hintText: 'Uporabniško ime',
                    hintStyle: _hintStyle,
                ),
                cursorColor: Colors.white,
                style: _inputStyle,
                onChanged: (text) => setState(() {}),
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
              )),
              _addPaddingAndMaxWidth(TextField(
                controller: _passwordController,
                focusNode: passwordFocusNode,
                onSubmitted: (_) => login(),
                decoration: InputDecoration(
                    hintText: 'Geslo',
                    hintStyle: _hintStyle,
                ),
                style: _inputStyle,
                cursorColor: Colors.white,
                obscureText: true,
                onChanged: (text) => setState(() {}),
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
              )),
              error,
              submitButton,
              Container(height: 64.0,)
            ],
          )]),
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
