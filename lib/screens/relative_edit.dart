import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../helpers/ensure-visible.dart';
import '../models/user.dart';
import '../scoped-models/mainmodel.dart';
import '../resources/repository.dart';
import '../ui_elements/adaptive_progress_indicator.dart';

class RelativeEditPage extends StatefulWidget {
  int selectedRelativeIndex;

  RelativeEditPage(this.selectedRelativeIndex);
  @override
  State<StatefulWidget> createState() {
    return _RelativeEditPageState(selectedRelativeIndex);
  }
}

class _RelativeEditPageState extends State<RelativeEditPage> {
  User _selectedRelative;
  int selectedRelativeIndex = -1;
  Repository _repository = null;

  final Map<String, dynamic> _formData = {
    'id': 0,
    'fio': null,
    'phone': null,
    'email': null
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _fioFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  //these fields needs controllers for not to lose values when are out of screen
  final _fioTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _emailTextController = TextEditingController();

  _RelativeEditPageState(this.selectedRelativeIndex);

  @override
  initState() {
    _repository = Repository();
    super.initState();
  }

  Widget _buildFioTextField(User user) {
    if (user == null && _fioTextController.text.isEmpty) {
      _fioTextController.text = '';
    } else if (user != null && _fioTextController.text.isEmpty) {
      _fioTextController.text = user.fio;
    }
    return EnsureVisibleWhenFocused(
        focusNode: _fioFocusNode,
        child: TextFormField(
          focusNode: _fioFocusNode,
          decoration: InputDecoration(
              labelText: 'ФИО', filled: true, fillColor: Colors.white),
          controller: _fioTextController,
          keyboardType: TextInputType.text,
          // validator: (String value) {
          //   if (value.isEmpty ||
          //       !RegExp(r"^[А-ЯЁ][а-яё]{2,}([-][А-ЯЁ][а-яё]{2,})?\s[А-ЯЁ][а-яё]{2,}\s[А-ЯЁ][а-яё]{2,}$")
          //           .hasMatch(value)) {
          //     return 'Необходимо ввести Ф.И.О через пробел с большой буквы.';
          //   }
          // },
          onSaved: (String value) {
            _formData['fio'] = value;
          },
        ));
  }

  Widget _buildPhoneTextField(User user) {
    if (user == null && _phoneTextController.text.isEmpty) {
      _phoneTextController.text = '';
    } else if (user != null && _phoneTextController.text.isEmpty) {
      _phoneTextController.text = user.phone;
    }
    return EnsureVisibleWhenFocused(
        focusNode: _phoneFocusNode,
        child: TextFormField(
          focusNode: _phoneFocusNode,
          decoration: InputDecoration(
              labelText: 'Телефон', filled: true, fillColor: Colors.white),
          controller: _phoneTextController,
          keyboardType: TextInputType.phone,
          // validator: (String value) {
          //   if (value.isEmpty ||
          //       !RegExp(r"^\+?[78][-\(]?\d{3}\)?-?\d{3}-?\d{2}-?\d{2}$")
          //           .hasMatch(value)) {
          //     return 'Необходимо ввести телефон.';
          //   }
          // },
          onSaved: (String value) {
            _formData['phone'] = value;
          },
        ));
  }

  Widget _buildEmailTextField(User user) {
    if (user == null && _emailTextController.text.isEmpty) {
      _emailTextController.text = '';
    } else if (user != null && _emailTextController.text.isEmpty) {
      _emailTextController.text = user.email;
    }
    return EnsureVisibleWhenFocused(
        focusNode: _emailFocusNode,
        child: TextFormField(
          focusNode: _emailFocusNode,
          decoration: InputDecoration(
              labelText: 'E - Mail', filled: true, fillColor: Colors.white),
          controller: _emailTextController,
          keyboardType: TextInputType.emailAddress,
          // validator: (String value) {
          //   if (value.isEmpty ||
          //       !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
          //           .hasMatch(value)) {
          //     return 'Необходимо ввести E-mail.';
          //   }
          // },
          onSaved: (String value) {
            _formData['email'] = value;
          },
        ));
  }

  _submitForm(Function addRelative, Function updateRelative,
      Function setSelectedRelative, selectedRelativeIndex) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedRelativeIndex == -1) {
      addRelative(_fioTextController.text, _phoneTextController.text,
              _emailTextController.text)
          .then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/admin')
              .then((_) => setSelectedRelative(null));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text('Something went wrong'),
                    content: Text('Please try again'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'))
                    ]);
              });
        }
      });
    } else {
      updateRelative(_fioTextController.text, _phoneTextController.text,
              _emailTextController.text)
          .then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/admin')
              .then((_) => setSelectedRelative(null));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text('Произошла ошибка!'),
                    content: Text('Попробуйте снова'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'))
                    ]);
              });
        }
      });
    }
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      child: Text('Сохранить'),
      textColor: Colors.white,
      onPressed: () => _submitForm(
            addRelative,
            updateRelative,
            selectRelative,
            selectedRelativeIndex,
          ),
    );
  }

  Widget _buildPageContent(BuildContext context, User relative) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = (deviceWidth - targetWidth) / 2;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: targetPadding),
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    _buildFioTextField(relative),
                    _buildPhoneTextField(relative),
                    _buildEmailTextField(relative),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildSubmitButton()
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    final Widget pageContent = _buildPageContent(context, _selectedRelative);
    return selectedRelativeIndex == -1
        ? pageContent
        : Scaffold(
            appBar: AppBar(title: Text("Редактировать контакт")),
            body: pageContent);
  }

  Future<bool> addRelative(fio, phone, email) async {
    int id = await _repository
        .addUserToCache(new User(fio: fio, phone: phone, email: email));
  }

  Future<bool> updateRelative(fio, phone, email) async {
    int id = await _repository.addUserToCache(new User(
        id: _selectedRelative.id, fio: fio, phone: phone, email: email));
    return (id > -1);
  }

  void selectRelative() {
    _repository.fetchUser(_selectedRelative.id);
  }

  void setSelectedRelative(User user) {
    _selectedRelative = user;
  }
}
