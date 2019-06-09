import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import 'package:scoped_model/scoped_model.dart';
import '../models/user.dart';
import '../utils/md5hash.dart';

final _urlRoot = 'https://sos-click.firebaseio.com/v0/users';

mixin ConnectedRelativesModel on Model {
  List<User> _relatives = [];
  User _currentUser;
  bool _isLoading = false;
  bool _isRegistered = false;
  bool get isLoading => _isLoading;
}

mixin UserModel on ConnectedRelativesModel {
  User _currentRelative;
  int _selRelativeId;
  int _selRelativeIndex;

  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _currentUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  List<User> get allRelatives {
    return List.from(_relatives);
  }

  List<User> get displayedRelatives {
    return List.from(_relatives);
  }

  int get selectedRelativeIndex {
    return _relatives.indexWhere((User user) {
      return user.id == _selRelativeId;
    });
  }

  int getRelativeIndex(int id) {
    return _relatives.indexWhere((User user) {
      return user.id == id;
    });
  }

  int get selectedRelativeId {
    return _selRelativeId;
  }

  User get selectedRelative {
    if (_selRelativeId == null) {
      return null;
    }
    return _relatives.firstWhere((User user) {
      return user.id == _selRelativeId;
    });
  }

  Future<Map<String, dynamic>> register(
      String fio, String phone, String email) async {
    _isLoading = true;
    notifyListeners();
    _currentUser = new User(fio: fio, phone: phone, email: email);
    final _currentHash = generateMd5(phone);

    http.Response response;

    response = await http.post(
      '$_urlRoot/$_currentHash/user.json',
      headers: {'Content-Type': 'application/json'},
      body: _currentUser.toJson(),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';
    if (responseData.containsKey('Id')) {
      hasError = false;
      message = 'Authentication succeeded';
      _currentUser =
          User(id: responseData['Id'], fio: fio, phone: phone, email: email);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userEmail', email);
      prefs.setString('userPhone', phone);
      prefs.setString('userFio', fio);
      prefs.setString('userId', responseData['Id']);
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'Email was not found';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid';
    }
    //print(json.decode(response.body));

    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoRegister() {}

  void fetchRelatives() {}

  void selectRelative(User user) {
    _selRelativeId = user.id;
  }

  void deleteSelectedRelative(bool delete) {}

  void logout() async {
    _selRelativeId = 0;
    _relatives = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('userFio');
    prefs.remove('userPhone');
    prefs.remove('userEmail');
  }

  void addRelative() {}

  void updateRelative() {}
}

mixin UtilityModel on ConnectedRelativesModel {
  bool get isLoading {
    return _isLoading;
  }
}
