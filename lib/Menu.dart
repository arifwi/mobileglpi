import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:amds/main.dart' as login;
import 'package:amds/addDevice.dart' as addDevice;
import 'package:amds/scan.dart' as scanner;
import 'package:amds/before_adddevice.dart' as scan_adddevice;
import 'package:amds/computerList.dart' as commputerlist;

class mainMenu extends StatefulWidget {
  final String username;

  mainMenu({this.username});

  @override
  _mainMenuState createState() => _mainMenuState();
}

class _mainMenuState extends State<mainMenu> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: backButtonDialog,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('AMDS Main Menu'),

          //new Text("${widget.username}"),
        ),
        body: new GridView.count(
          crossAxisCount: 3,
          children: <Widget>[
            new GestureDetector(
              child: new Card(
                  child: Column(
                children: <Widget>[
                  Icon(
                    Icons.computer,
                    size: 75.0,
                  ),
                  Text(
                    'Computers',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => scan_adddevice.scanning()));
                //MaterialPageRoute(builder: (context) => addDevice.mainAdd()));
              },
            ),
            new GestureDetector(
              child: new Card(
                  child: Column(
                children: <Widget>[
                  Icon(
                    Icons.print,
                    size: 75.0,
                  ),
                  Text(
                    'Printers',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              )),
              onTap: () {
              }
            ),
            new GestureDetector(
              child: new Card(
                  child: Column(
                children: <Widget>[
                  Icon(
                    Icons.reply,
                    size: 75.0,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              )),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => login.MyApp()),
                );
              },
            ),
            new GestureDetector(
              child: new Card(
                  child: Column(
                children: <Widget>[
                  Icon(
                    Icons.accessibility,
                    size: 75.0,
                  ),
                  Text(
                    'Test',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              )),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => scanner.scan()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> backButtonDialog() {
    AlertDialog alertScanDeviceid = new AlertDialog(
      title: new Text('Exit Dialog', style: new TextStyle(color: Colors.blue)),
      content: new Text('Do you want to exit from this application?'),
      actions: <Widget>[
        new RaisedButton.icon(
          color: Colors.blue,
          icon: new Icon(
            Icons.close,
            color: Colors.white,
          ),
          label: new Text(
            'No',
            style: new TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        new RaisedButton.icon(
          color: Colors.blue,
          icon: new Icon(Icons.exit_to_app, color: Colors.white),
          label: new Text(
            'Yes',
            style: new TextStyle(color: Colors.white),
          ),
          onPressed: () {
            exit(0);
            //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> menu.mainMenu()));
          },
        )
      ],
    );
    return showDialog(context: context, child: alertScanDeviceid);
  }
}
