import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/user.dart';

import '../ui_elements/adaptive_progress_indicator.dart';

class AuthPage extends StatefulWidget {
  final Function register;
  AuthPage(this.register);

  @override
  State<StatefulWidget> createState() {
    return _AuthPageState(this.register);
  }
}

class _AuthPageState extends State<AuthPage> {
  final Function register;

  final Map<String, dynamic> _authFormData = {
    'fio': null,
    'phone': null,
    'email': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _authFormKey = GlobalKey<FormState>();

  _AuthPageState(this.register);

  @override
  void initState() {
    super.initState();
  }

  void showToast(String messageText) {
    Fluttertoast.showToast(
        msg: messageText, toastLength: Toast.LENGTH_SHORT, timeInSecForIos: 1);
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
        image: AssetImage('assets/images/background.jpg'));
  }

  Widget _buildFioTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'ФИО', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"^[А-ЯЁ][а-яё]{2,}([-][А-ЯЁ][а-яё]{2,})?\s[А-ЯЁ][а-яё]{2,}\s[А-ЯЁ][а-яё]{2,}$")
                .hasMatch(value)) {
          return 'Необходимо ввести Ф.И.О через пробел.';
        }
      },
      onSaved: (String value) {
        _authFormData['email'] = value;
      },
    );
  }

  Widget _buildPhoneTextField() {
    return TextFormField(
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
        _authFormData['email'] = value;
      },
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
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
        _authFormData['email'] = value;
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _authFormData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _authFormData['acceptTerms'] = value;
        });
      },
      title: Text('Принять соглашение'),
    );
  }

  void _submitForm(Function register) async {
    if (!_authFormKey.currentState.validate()) {
      return; /*  */
    }

    if (!_authFormData['acceptTerms']) {
      showToast('Соглашение не принято!');
      return;
    }

    _authFormKey.currentState.save();
    Map<String, dynamic> _successInfo;
    _successInfo = await register(new User(
        fio: _authFormData['fio'],
        phone: _authFormData['phone'],
        email: _authFormData['email']));
    //print(successInfo);
    if (_successInfo['success']) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Произошла ошибка'),
              content: Text(_successInfo['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return Scaffold(
        appBar: AppBar(
          title: Text('Зарегистрируйтесь'),
        ),
        body: Container(
            decoration: BoxDecoration(image: _buildBackgroundImage()),
            padding:
                EdgeInsets.only(bottom: 0.0, left: 16.0, right: 16.0, top: 4.0),
            child: Center(
                child: SingleChildScrollView(
              child: Container(
                  alignment: Alignment.center,
                  width: targetWidth,
                  child: Form(
                      key: _authFormKey,
                      child: Column(children: <Widget>[
                        _buildFioTextField(),
                        SizedBox(
                          height: 8.0,
                        ),
                        _buildPhoneTextField(),
                        SizedBox(
                          height: 8.0,
                        ),
                        _buildEmailTextField(),
                        SizedBox(
                          height: 8.0,
                        ),
                        _buildAcceptSwitch(),
                        SizedBox(
                          height: 2.0,
                        ),
                        // Center(child: ScopedModelDescendant<MainModel>(builder:
                        //     (BuildContext context, Widget child,
                        //         MainModel model) {
                        //   return model.isLoading
                        //       ? AdaptiveProgressIndicator()
                        //       : RaisedButton(
                        //           color: Theme.of(context).primaryColor,
                        //           textColor: Colors.white,
                        //           child: Text('Регистрация'),
                        //           onPressed: () => _submitForm(model.register));
                        // }))
                        Center(
                          child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: Text('Регистрация'),
                              onPressed: () => _submitForm(register)),
                        )
                      ]))),
            ))));
  }
}
