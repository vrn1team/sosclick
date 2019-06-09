import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../helpers/ensure-visible.dart';
import '../models/user.dart';
import '../scoped-models/mainmodel.dart';
import '../ui_elements/adaptive_progress_indicator.dart';

class RelativeEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RelativeEditPageState();
  }
}

class _RelativeEditPageState extends State<RelativeEditPage> {
  final Map<String, dynamic> _formData = {
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
          keyboardType: TextInputType.text,
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r"^[А-ЯЁ][а-яё]{2,}([-][А-ЯЁ][а-яё]{2,})?\s[А-ЯЁ][а-яё]{2,}\s[А-ЯЁ][а-яё]{2,}$")
                    .hasMatch(value)) {
              return 'Необходимо ввести Ф.И.О через пробел с большой буквы.';
            }
          },
          onSaved: (String value) {
            _formData['email'] = value;
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
          keyboardType: TextInputType.phone,
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r"^\+?[78][-\(]?\d{3}\)?-?\d{3}-?\d{2}-?\d{2}$")
                    .hasMatch(value)) {
              return 'Необходимо ввести телефон.';
            }
          },
          onSaved: (String value) {
            _formData['email'] = value;
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
          keyboardType: TextInputType.emailAddress,
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(value)) {
              return 'Необходимо ввести E-mail.';
            }
          },
          onSaved: (String value) {
            _formData['email'] = value;
          },
        ));
  }

  _submitForm(Function addRelative, Function updateRelative,
      Function setSelectedRelative,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate() ||
        (_formData['image'] == null && selectedProductIndex == -1)) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == -1) {
      addRelative(_fioTextController.text, _phoneTextController.text,
              _emailTextController.text)
          .then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/relatives')
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
          Navigator.pushReplacementNamed(context, '/relatives')
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
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.isLoading
          ? Center(child: AdaptiveProgressIndicator())
          : RaisedButton(
              child: Text('Save'),
              textColor: Colors.white,
              onPressed: () => _submitForm(
                  model.addRelative,
                  model.updateRelative,
                  model.selectRelative,
                  model.selectedRelativeIndex),
            );
    });
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
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Widget pageContent =
          _buildPageContent(context, model.selectedRelative);
      return model.selectedRelativeIndex == -1
          ? pageContent
          : Scaffold(
              appBar: AppBar(title: Text("Редактировать контакт")),
              body: pageContent);
    });
  }
}
