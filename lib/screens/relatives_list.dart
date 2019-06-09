import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './relative_edit.dart';
import '../scoped-models/mainmodel.dart';

class RelativesListPage extends StatefulWidget {
  final MainModel model;

  RelativesListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _RelativesListPageState();
  }
}

class _RelativesListPageState extends State<RelativesListPage> {
  @override
  initState() {
    widget.model.fetchRelatives();
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          model.selectRelative(model.allRelatives[index]);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return RelativeEditPage();
          })).then((_) => model.selectRelative(null));
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
              key: Key(model.allRelatives[index].phone),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectRelative(model.allRelatives[index]);
                  model.deleteSelectedRelative(true);
                } else if (direction == DismissDirection.startToEnd) {
                  print("Swiped start to end");
                } else {
                  print("Other direction");
                }
              },
              background: Container(color: Colors.red),
              child: Column(
                children: <Widget>[
                  ListTile(
                      title: Text(model.allRelatives[index].fio),
                      subtitle: Text(
                          '\$${model.allRelatives[index].phone.toString()}'),
                      trailing: _buildEditButton(context, index, model)),
                  Divider()
                ],
              ));
        },
        itemCount: model.allRelatives.length,
      );
    });
  }
}
