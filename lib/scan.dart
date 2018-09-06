import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:amds/addDevice.dart' as adddevice;
import 'dart:io';

import 'package:flutter/services.dart';

class scan extends StatefulWidget {
  @override
  _scanningState createState() => _scanningState();
}

class _scanningState extends State<scan> {
  String strText = 'ABCDEFG';
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blue, 
    body: new Column(
      children: <Widget>[
        new Text(strText),
        new RaisedButton(
          child: new Text('Button'),
          onPressed: (){
            
          },
        )
      ],
    )
    );
  }
}
