import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/location.dart' as geoloc;

import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import './screens/DisplayPictureScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './shared/adaptive_theme.dart';
import './screens/auth.dart';
import './screens/sos.dart';
import './screens/relatives_admin.dart';
import './scoped-models/mainmodel.dart';
import './models/user.dart';

Future<void> main() async {
  // Добавить получение permissions  - все

  // Получить доступные камеры
  final cameras = await availableCameras();
  // Берем первую камеру, пока так
  final firstCamera = cameras.first;

  runApp(SOSClickApp(
    camera: firstCamera,
  ));
}

class SOSClickApp extends StatefulWidget {
  final CameraDescription camera;

  SOSClickApp({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SOSClickAppState();
  }
}

class _SOSClickAppState extends State<SOSClickApp> {
  bool _isRegistered = false;
  final MainModel _model = MainModel();

  @override
  void initState() {
    // _model.autoRegister();
    // _model.userSubject.listen((bool isRegistered) {
    //   setState(() {
    //     _isRegistered = isRegistered;
    //   });
    // });

    checkRegistration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // localizationsDelegates: [
        //   // ... app-specific localization delegate[s] here
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        // ],
        // supportedLocales: [
        //   const Locale('en'), // English
        //   const Locale('ru'), // Russian
        // ],
        title: 'SOS Клик',
        theme: getAdaptiveTheme(context),
        routes: {
          '/': (BuildContext context) => !_isRegistered
              ? AuthPage(register)
              : SOSPage(camera: widget.camera, title: 'SOS'),
          '/admin': (BuildContext context) =>
              !_isRegistered ? AuthPage(register) : RelativesAdminPage()
        },
        //!! dynamically parsed route
        onGenerateRoute: (RouteSettings settings) {
          if (!_isRegistered) {
            return MaterialPageRoute(
                builder: (BuildContext context) => AuthPage(register));
          }
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }

          if (pathElements[1] == 'relatives') {
            return MaterialPageRoute(
                builder: (BuildContext context) => RelativesAdminPage());
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          // home page !!!
          return MaterialPageRoute(
            builder: (BuildContext context) => !_isRegistered
                ? AuthPage(register)
                : SOSPage(camera: widget.camera, title: 'SOS'),
          );
        });
  }

  void register(User user) async {
    //Записать в преференсес
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userEmail', user.email);
    prefs.setString('userPhone', user.phone);
    prefs.setString('userFio', user.fio);
    prefs.setInt('userId', 1);

    this.checkRegistration();
  }

  void unregister() async {
    //Очистить преференсес
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('userFio');
    prefs.remove('userPhone');
    prefs.remove('userEmail');
  }

  void checkRegistration() async {
    //Есть преференсы
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if ((prefs.getInt('userId') ?? 0) == 0) {
      return;
    }
    setState(() {
      _isRegistered = true;
    });
  }
}
