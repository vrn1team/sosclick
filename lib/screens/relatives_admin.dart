import 'package:flutter/material.dart';

import './relative_edit.dart';
import './relatives_list.dart';
import '../resources/repository.dart';
import '../ui_elements/clean_registration_tile.dart';

import 'dart:async';

class RelativesAdminPage extends StatelessWidget {
  final String title = "Контакты";

  RelativesAdminPage();

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          automaticallyImplyLeading: false,
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          title: Text('Контакты'),
        ),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Главная'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        Divider(),
        CleanRegistrationTile(),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(false);
        },
        child: DefaultTabController(
            length: 2,
            child: Scaffold(
                drawer: _buildSideDrawer(context),
                appBar: AppBar(
                  title: Text('Добавить контакты'),
                  elevation: Theme.of(context).platform == TargetPlatform.iOS
                      ? 0.0
                      : 4.0,
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(Icons.create),
                        text: 'Создать контакт',
                      ),
                      Tab(icon: Icon(Icons.list), text: 'Мои контакты'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    //these pages are embedded!!! return only body!!!
                    RelativeEditPage(-1),
                    RelativesListPage()
                  ],
                ))));
  }
}
