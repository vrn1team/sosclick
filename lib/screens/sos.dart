import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/location.dart' as geoloc;

import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import '../screens/DisplayPictureScreen.dart';
import '../screens/help.dart';
import '../ui_elements/clean_registration_tile.dart';

class SOSPage extends StatefulWidget {
  final String title;
  final CameraDescription camera;

  SOSPage({
    Key key,
    @required this.title,
    @required this.camera,
  }) : super(key: key);

  @override
  _SOSPageState createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  final int _initialCounter = 2;
  int _counter = 2;
  bool _visible = false;
  String _locationInfo = '';
  String _userInfo = '';

  @override
  void initState() {
    super.initState();
    _counter = _initialCounter;

    // In order to display the current output from the Camera, you need to
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras
      widget.camera,
      // Define the resolution to use
      ResolutionPreset.medium,
    );

    // Next, you need to initialize the controller. This returns a Future
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Make sure to dispose of the controller when the Widget is disposed
    _controller.dispose();
    super.dispose();
  }

  void _callEmergency() {
    _getUserLocation();
    _takePhoto();
    _sendSMS();

    //_visible = true;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpScreen(info: _userInfo + ' ' + _locationInfo),
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (_counter > 0) {
        _visible = false;
        _counter--;
      } else {
        _counter = _initialCounter;
        _callEmergency();
      }
    });
  }

  void _takePhoto() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure the camera is initialized
      await _initializeControllerFuture;

      // Construct the path where the image should be saved using the path
      // package.
      final path = join(
        // In this example, store the picture in the temp directory. Find
        // the temp directory using the `path_provider` plugin.
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      // Attempt to take a picture and log where it's been saved
      await _controller.takePicture(path);

      // If the picture was taken, display it on a new screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DisplayPictureScreen(imagePath: path),
      //   ),
      // );
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  void _getUserLocation() async {
    final location = geoloc.Location();
    try {
      final currentLocation = await location.getLocation();
      setState(() {
        _locationInfo = '' +
            currentLocation.latitude.toString() +
            ' ' +
            currentLocation.longitude.toString() +
            ' ' +
            currentLocation.altitude.toString();
      });
    } catch (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Невозможно определить местоположение'),
              content: Text('Пожалуйста сообщите местоположение.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  void _sendSMS() {}

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
        image: AssetImage('assets/images/background.png'));
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: Text('Действия'),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Контакты'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/admin');
          },
        ),
        Divider(),
        CleanRegistrationTile(),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
          decoration: BoxDecoration(image: _buildBackgroundImage()),
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: _incrementCounter,
                    child: CircleAvatar(
                      backgroundImage:
                          ExactAssetImage('assets/images/eButton.png'),
                      minRadius: 120,
                      maxRadius: 150,
                    ),
                  ),
                ),
                Text(
                  '${_counter + 1}',
                  style: Theme.of(context).textTheme.display1,
                ),
                Visibility(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(_locationInfo),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'Помощь идет ...',
                        style: Theme.of(context).textTheme.display1,
                      ),
                      Text(_locationInfo),
                    ],
                  ),
                  visible: _visible,
                ),
              ],
            ),
          )),
    );
  }
}
