import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

// A Widget that displays the picture taken by the user
class HelpScreen extends StatelessWidget {
  final String info;

  const HelpScreen({Key key, this.info}) : super(key: key);

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
        image: AssetImage('assets/images/background.png'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ожидайте')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image
      body: Container(
          decoration: BoxDecoration(image: _buildBackgroundImage()),
          child: Center(
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(info),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  'Помощь идет ...',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          )),
    );
  }
}
