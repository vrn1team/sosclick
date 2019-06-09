import 'package:flutter/material.dart';
import '../models/user.dart';

import './relative_edit.dart';
import '../resources/repository.dart';

class RelativesListPage extends StatefulWidget {
  RelativesListPage();

  @override
  State<StatefulWidget> createState() {
    return _RelativesListPageState();
  }
}

class _RelativesListPageState extends State<RelativesListPage> {
  Repository _repository = null;
  List<User> relatives = [];
  User _selectedRelative = null;

  @override
  initState() {
    _repository = Repository();
    fetchRelatives();
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index) {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          selectRelative(relatives[index]);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return RelativeEditPage(index);
          })).then((_) => selectRelative(null));
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
            key: Key(relatives[index].id.toString()),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                selectRelative(relatives[index]);
                deleteSelectedRelative();
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
                    title: Text(relatives[index].fio.toString()),
                    subtitle: Text(relatives[index].phone.toString()),
                    trailing: _buildEditButton(context, index)),
                Divider()
              ],
            ));
      },
      itemCount: relatives.length,
    );
  }

  void fetchRelatives() async {
    List<User> newrelatives = await Repository().fetchUsersFromCache();
    setState(() {
      relatives = newrelatives;
    });
  }

  void selectRelative(User user) {
    _selectedRelative = user;
  }

  void deleteSelectedRelative() async {
    if (_selectedRelative == null) {
      return;
    }
    List<User> newrelatives =
        await Repository().deleteUserFromCache(_selectedRelative);
    setState(() {
      relatives = newrelatives;
    });
  }
}
