import 'package:flutter/material.dart';

void main() => runApp(SOSClickApp());

class SOSClickApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SOSClickAppState();
  }
}

class _SOSClickAppState extends State<SOSClickApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOS Click',
      theme: ThemeData(
          primarySwatch: Colors.deepOrange, accentColor: Colors.redAccent),
      home: SOSHomePage(title: 'SOS click home page'),
    );
  }
}

class SOSHomePage extends StatefulWidget {
  SOSHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SOSHomePageState createState() => _SOSHomePageState();
}

class _SOSHomePageState extends State<SOSHomePage> {
  int _counter = 0;
  bool _visible = false;

  void _callEmergency() {}

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (_counter < 3) {
        _counter++;
      } else {
        _visible = true;
        _callEmergency();
      }
    });
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
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: FlatButton(
                onPressed: _incrementCounter,
                child: Icon(Icons.add),
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            Visibility(
              child: Text(
                'Calling the emergency ...',
                style: Theme.of(context).textTheme.display1,
              ),
              visible: _visible,
            ),
          ],
        ),
      ),
    );
  }
}
