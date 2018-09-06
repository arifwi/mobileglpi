import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amds/Menu.dart';

void main() => runApp(new MyApp());
String username = '';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'AMDS',
      home: new LoginPage(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/mainMenu': (BuildContext context) => new mainMenu(username: username),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txt_username = new TextEditingController();
  TextEditingController txt_password = new TextEditingController();

  String message = '';
  String url = 'http://192.168.168.190/amds/';
  Future<dynamic> _checkLogin() async {
    setState(() {
      message = '';
    });
    try {
      final response = await http.post(url + "login.php", body: {
        //http://192.168.168.190/amds/login.php
        //http://192.168.43.62/amds/login.php
        //10.66
        'username': txt_username.text,
        'password': txt_password.text,
      });
      if (response.statusCode == 200) {
        var datauser = json.decode(response.body);
        if (datauser.length == 0) {
          setState(() {
            message = 'Login Filed';
          });
        } else {
          //print(datauser[0]["username"]);
          Navigator.pushReplacementNamed(context, "/mainMenu");
          setState(() {
            username = datauser[0]["username"];
            //print(username);
          });
        }
      }
      else{
        message = 'Connection failed';
      }
    } catch (e) {
      print(e);
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Login'),
          ),
          body: ListView(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(top: 50.0),
                  ),
                  new Text('AMDS',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25.0)),
                  new Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  new TextField(
                    controller: txt_username,
                    decoration: InputDecoration(hintText: 'Username'),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  new TextField(
                    controller: txt_password,
                    decoration: InputDecoration(hintText: 'Password'),
                    obscureText: true,
                  ),
                ],
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              new RaisedButton(
                color: Colors.blueAccent,
                child: new Text(
                  'Login',
                  style: TextStyle(fontSize: 18.0),
                ),
                onPressed: () {
                  _checkLogin();
                },
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              new Text(
                message,
                style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          )),
    );
  }
}
