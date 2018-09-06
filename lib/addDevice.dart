import 'dart:async';
import 'dart:convert';

import 'package:amds/Menu.dart' as menu;
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:simple_permissions/simple_permissions.dart';
import 'package:amds/before_adddevice.dart' as scan;

class mainAdd extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;

  String strDeviceId, strPN, strSN;
  mainAdd(
      {this.onPressed,
      this.tooltip,
      this.icon,
      this.strDeviceId,
      this.strSN,
      this.strPN});

  @override
  mainAddState createState() {
    return new mainAddState();
  }
}

class mainAddState extends State<mainAdd> with SingleTickerProviderStateMixin {
  Permission permission = Permission.Camera;

  TextEditingController controllerDeviceId = new TextEditingController();
  TextEditingController controllerSerialNumber = new TextEditingController();
  TextEditingController controllerProductNumber = new TextEditingController();
  TextEditingController controllerLocation = new TextEditingController();
  TextEditingController controllerUser = new TextEditingController();

  FocusNode fDeviceId = new FocusNode();
  FocusNode fSerialNumber = new FocusNode();
  FocusNode fProductNumber = new FocusNode();
  FocusNode fLocation = new FocusNode();
  FocusNode fUser = new FocusNode();

  bool enableDeviceID, enableSN, enablePN;

  String _selectedType, _selectedModel, selectedTypeName, selectedModelName;

  List<DropdownMenuItem<String>> dataType = [];
  List<DropdownMenuItem<String>> dataModel = [];
  //List<UserDetails> txtselectedType, txtselectedModel;
  List<MapTypeModel> _listDataType = [];
  List<MapTypeModel> _searchTypeResult = [];
  List<MapTypeModel> _listDataModel = [];
  List<MapTypeModel> _searchModelResult = [];

  var _result;

  String qresult = '';
  String url = 'http://192.168.168.190/amds/';

  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  bool _isUnlock = true;
  Icon iconLock = new Icon(Icons.lock);
  Icon iconLockOpen = new Icon(Icons.lock_open);
   String aaa ;
  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  Widget wlockUnlock() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          
        },
        tooltip: 'Save the new device',
        child: _isUnlock == true ? iconLockOpen : iconLock,
      ),
    );
  }

  Widget wScan() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (context) => scan.scanning(
                        deviceID: controllerDeviceId.text,
                        sn: controllerSerialNumber.text,
                        pn: controllerProductNumber.text,
                      )));
        },
        tooltip: 'Back to scanning page',
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String resultID = '${widget.strDeviceId}',
        resultSN = '${widget.strSN}',
        resultPN = '${widget.strPN}';
    if (_result == null) {
      //Lakukan sesuatu sambil menunggu proses get dari database

      return new Scaffold(
          appBar: new AppBar(),
          body: new Container(
            child: new LinearProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ));
    }
    if (aaa != 'null') {
      controllerDeviceId.text = aaa;
      enableDeviceID = false;
      
            
      
    }
    if (resultSN != 'null') {
      controllerSerialNumber.text = resultSN;
      enableSN = false;
      

    }
    if (resultPN != 'null') {
      controllerProductNumber.text = resultPN;
      enablePN = false;
      

    }

    return WillPopScope(
      onWillPop: backButtonDialog,
      child: Scaffold(
        appBar: new AppBar(
          title: Text('Add New Device'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: backButtonDialog,
          ),
          actions: <Widget>[
            new RaisedButton.icon(
              icon: new Icon(Icons.save_alt),
              onPressed: inputConfirmDialog,
              label: new Text('Save'),
              color: Colors.green,
            ),
          ],
        ),
        floatingActionButton: new Row(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
            ),
            new FloatingActionButton(
              child: iconLock,
              onPressed: () {
            enableDeviceID = true;
              },
            ),
          ],
        ),
        body: new Stack(
          children: <Widget>[
            new ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
                  child: TextField(
                    enabled: enableDeviceID,
                    focusNode: fDeviceId,
                    controller: controllerDeviceId,
                    decoration: InputDecoration(
                        labelText: 'ID Device',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10.0, left: 20.0, top: 15.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      iconSize: 20.0,
                      style: TextStyle(fontSize: 17.0, color: Colors.black),
                      value: _selectedType,
                      items: dataType,
                      hint: Text('Select Type'),
                      onChanged: (value) {
                        setState(() {
                          _searchTypeResult = [];

                          _selectedType = value;
                          _selectedModel = null;
                          //print(_selectedType);
                          //print(_userDetails[int.tryParse(_selectedType)].name);
                          _listDataType.forEach((MapTypeModel) {
                            if (MapTypeModel.id.contains(_selectedType))
                              _searchTypeResult.add(MapTypeModel);
                          });
                          //print(_searchResult);
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10.0, left: 20.0, top: 15.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      iconSize: 20.0,
                      style: TextStyle(fontSize: 17.0, color: Colors.black),
                      value: _selectedModel,
                      items: dataModel,
                      hint: Text('Select Model'),
                      onChanged: (valuemodel) {
                        _searchModelResult = [];
                        //var result = List<dynamic>.
//                        print(_searchResult[1].name);
                        // print(_searchTypeResult[0].name);

                        setState(() {
                          _selectedModel = valuemodel;
                          _listDataModel.forEach((MapTypeModel) {
                            if (MapTypeModel.id.contains(_selectedModel))
                              _searchModelResult.add(MapTypeModel);
                          });
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
                  child: TextField(
                    enabled: enableSN,
                    focusNode: fSerialNumber,
                    controller: controllerSerialNumber,
                    decoration: InputDecoration(
                        labelText: 'Serial Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
                  child: TextField(
                    enabled: enablePN,
                    focusNode: fProductNumber,
                    controller: controllerProductNumber,
                    decoration: InputDecoration(
                        labelText: 'Product Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
                  child: TextField(
                    focusNode: fLocation,
                    controller: controllerLocation,
                    decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
                  child: TextField(
                    focusNode: fUser,
                    controller: controllerUser,
                    decoration: InputDecoration(
                        labelText: 'User',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
              ],
            ),
            Positioned(
                bottom: 16.0,
                right: 16.0,
                child: Column(
                  children: <Widget>[
                    Transform(
                      transform: Matrix4.translationValues(
                        0.0,
                        _translateButton.value * 2.0,
                        0.0,
                      ),
                      child: wlockUnlock(),
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                        0.0,
                        _translateButton.value,
                        0.0,
                      ),
                      child: wScan(),
                    ),
                    toggle(),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  //METHOD OR FUNCTION ARE HERE//

  @override
  void initState() {
    // TODO: implement initState
    aaa = widget.strDeviceId;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();

    getcomputerTypes().then((result) {
      new Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _result = result;
          getcomputerModels();
        });
      });
    });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Future getcomputerTypes() async {
    try {
      final getTypeResult = await http.get(url + 'getComputerTypes.php');

      final getdataType = json.decode(getTypeResult.body);

      dataType = [];
      //txtselectedType = getdataType;
      for (Map i in getdataType) {
        _listDataType.add(MapTypeModel.fromJson(i));
      }

      for (var i = 0; i < _listDataType.length; i++) {
        Color color;
        if (i % 2 != 0) {
          color = Colors.amber;
        } else {
          color = Colors.blue[300];
        }
        dataType.add(new DropdownMenuItem(
          child: new Text(
            (_listDataType[i].name),
            style: new TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          value: _listDataType[i].id.toString(),
        ));
      }
      return dataType;
    } catch (error) {
      print(error);
    }
  }

  Future<dynamic> getcomputerModels() async {
    try {
      final getModelResult = await http.get(url + 'getComputerModels.php');

      final getdatamodel = json.decode(getModelResult.body);
      //print(getdatamodel.length.toString());
      //for(Map a in )
      for (Map i in getdatamodel) {
        _listDataModel.add(MapTypeModel.fromJson(i));
      }
      for (var i = 0; i < _listDataModel.length; i++) {
        //txtselectedModel.add(getdatamodel)
        Color color;
        if (i % 2 != 0) {
          color = Colors.amber;
        } else {
          color = Colors.blue[300];
        }
        dataModel.add(new DropdownMenuItem(
          child: new Text(
            (_listDataModel[i].name),
            style: new TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          value: _listDataModel[i].id.toString(),
        ));
      }
      return dataModel;
    } catch (error) {
      print(error);
    }
  }

  Future<bool> backButtonDialog() {
    AlertDialog alertBackButton = new AlertDialog(
      title: new Row(
        children: <Widget>[
          Icon(Icons.warning, color: Colors.blue),
          Text(
            'Warning',
            style: new TextStyle(color: Colors.blue),
          )
        ],
      ),
      content:
          new Text('All changes will be discarded, do you want to continue?'),
      actions: <Widget>[
        new RaisedButton(
          color: Colors.green,
          child: new Text(
            'No',
            style: new TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        new RaisedButton(
          color: Colors.red,
          child: new Text(
            'Yes',
            style: new TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context, true);
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (context) => menu.mainMenu()));
          },
        )
      ],
    );
    return showDialog(context: context, child: alertBackButton);
  }

  Future<bool> inputConfirmDialog() {
    if (_selectedType != null &&
        _selectedModel != null &&
        controllerDeviceId.text != "" &&
        controllerProductNumber.text != "" &&
        controllerLocation.text != "" &&
        controllerSerialNumber.text != "" &&
        controllerUser.text != "") {
      AlertDialog alertInputConfirmation = new AlertDialog(
          title: const Text(
            'Input Confirmation',
          ),
          content: new ListView(
            children: <Widget>[
              new ListTile(
                leading:
                    new Text('ID : ', style: new TextStyle(color: Colors.blue)),
                title: new Text(controllerDeviceId.text,
                    style: new TextStyle(color: Colors.green)),
              ),
              new ListTile(
                leading: new Text('Type : ',
                    style: new TextStyle(color: Colors.blue)),
                title: new Text(
                  //'${txtselectedType[int.tryParse(_selectedType)+1]["name"]}',
                  _searchTypeResult[0].name,
                  style: new TextStyle(color: Colors.green),
                ),
              ),
              new ListTile(
                leading: new Text('Model : ',
                    style: new TextStyle(color: Colors.blue)),
                title: new Text(
                  _searchModelResult[0].name,
                  style: new TextStyle(color: Colors.green),
                ),
              ),
              new ListTile(
                leading: new Text(
                  'S. Number : ',
                  style: new TextStyle(color: Colors.blue),
                ),
                title: new Text(
                  controllerSerialNumber.text,
                  style: new TextStyle(color: Colors.green),
                ),
              ),
              new ListTile(
                leading: new Text('P. Number : ',
                    style: new TextStyle(color: Colors.blue)),
                title: new Text(
                  controllerProductNumber.text,
                  style: new TextStyle(color: Colors.green),
                ),
              ),
              new ListTile(
                leading: new Text('Location : ',
                    style: new TextStyle(color: Colors.blue)),
                title: new Text(
                  controllerLocation.text,
                  style: new TextStyle(color: Colors.green),
                ),
              ),
              new ListTile(
                leading: new Text('User : ',
                    style: new TextStyle(color: Colors.blue)),
                title: new Text(
                  controllerLocation.text,
                  style: new TextStyle(color: Colors.green),
                ),
              ),
              new ListTile(
                leading: new RaisedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: new Text('Cancel'),
                  color: Colors.red[300],
                ),
                trailing: new RaisedButton(
                  onPressed: () {
                    inputNewComputer(
                        controllerDeviceId.text,
                        _selectedType,
                        _selectedModel,
                        controllerSerialNumber.text,
                        controllerProductNumber.text,
                        controllerLocation.text,
                        controllerUser.text).then((_result) {
                      new Future.delayed(Duration(milliseconds: 500), () {
                        Navigator.pop(context, true);
                        successInputDialog();
                      });
                    });
                  },
                  child: new Text('Save'),
                  color: Colors.green[400],
                ),
              )
            ],
          ));

      return showDialog(context: context, child: alertInputConfirmation);
    } else {
      AlertDialog alertInputConfirmation = new AlertDialog(
        title: new Row(
          children: <Widget>[
            new Icon(
              Icons.warning,
              color: Colors.red,
            ),
            new Padding(
              padding: EdgeInsets.only(right: 5.0),
            ),
            new Text(
              'STOP',
              style: new TextStyle(color: Colors.red),
            )
          ],
        ),
        content: new Text('Please fill the empty field on the form!'),
        actions: <Widget>[
          new RaisedButton(
            child: new Text(
              'OK',
              style: new TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            onPressed: () => Navigator.pop(context, true),
          )
        ],
      );

      return showDialog(context: context, child: alertInputConfirmation);
    }
  }

  Future inputNewComputer(
      String computerId,
      String computerTypes_id,
      String computerModels_id,
      String sn,
      String pn,
      String locations_id,
      String users_id) async {
    String result;
    try {
      final response = await http.post(url + "inputNewComputer.php", body: {
        'id': computerId,
        'model_id': computerModels_id,
        'type_id': computerTypes_id,
        'sn': sn,
        'pn': pn,
        'user_id': users_id,
        'location_id': locations_id,
      });
      if (response.body == "DUPLICATE ID DETECTED") {
        result = "Duplicate ID has been detected";
      } else {
        result = "Input has been successfull";
      }
      setState(() {
        isSuccessInput = result;
      });
    } catch (e) {
      print(e);
    }
  }

  String isSuccessInput;
  Future<bool> successInputDialog() {
    AlertDialog successInputInfo = new AlertDialog(
      title: new Text(
        'Information',
        style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      content: new Text(isSuccessInput),
    );
    return showDialog(context: context, child: successInputInfo);
  }
}

class MapTypeModel {
  //used by get selected type and selected model
  final String id;
  final String name;

  MapTypeModel({this.id, this.name});

  factory MapTypeModel.fromJson(Map<String, dynamic> json) {
    return new MapTypeModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
