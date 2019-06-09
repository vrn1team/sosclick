import 'dart:convert';
import 'package:flutter/material.dart';

class CurrentUser {
  final int id;
  final String hash;

  CurrentUser({@required this.id, @required this.hash});

  CurrentUser.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        hash = parsedJson['hash'];

  toJson() {
    return jsonEncode(this);
  }

  CurrentUser.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        hash = map['hash'];

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{"id": id, "hash": hash};
  }
}
