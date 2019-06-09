import 'package:http/http.dart' as http show Client, Response;
import 'dart:convert';
import 'dart:async';
import '../models/user.dart';
import '../models/currentuser.dart';

import 'repository.dart';

final _urlRoot = 'https://sos-click.firebaseio.com/v0';

class UsersApiProvider implements Source {
  http.Client client = http.Client();

  Future<CurrentUser> fetchCurrentUser(String hash) async {
    final http.Response response =
        await client.get('$_urlRoot/registered/$hash.json');
    final parsedJson = json.decode(response.body);

    return CurrentUser.fromJson(parsedJson);
  }

  Future<User> fetchUser(int id) async {
    final http.Response response = await client.get('$_urlRoot/user/$id.json');
    final parsedJson = json.decode(response.body);

    return User.fromJson(parsedJson);
  }

  Future<int> addCurrentUser(CurrentUser currentuser) async {
    final http.Response response =
        await client.post('$_urlRoot/registered/', body: currentuser.toJson());
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode > 299) {
      return null;
    }
    return (json.decode(response.body)).id;
  }

  Future<int> addUser(User user) async {
    final http.Response response =
        await client.post('$_urlRoot/user/', body: user.toJson());
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode > 299) {
      return null;
    }
    return (json.decode(response.body)).id;
  }
}
