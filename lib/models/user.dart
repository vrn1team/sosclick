import 'dart:convert';
import 'package:flutter/material.dart';

class User {
  final int id;
  final String fio;
  final String phone;
  final String email;
  final List<dynamic> relatives;

  User(
      {this.id,
      @required this.fio,
      @required this.email,
      @required this.phone,
      this.relatives});

  User.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        fio = parsedJson['fio'],
        email = parsedJson['email'],
        phone = parsedJson['phone'],
        relatives = parsedJson['relatives'] ?? [];

  User.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        fio = map['fio'],
        email = map['email'],
        phone = map['phone'],
        relatives = jsonDecode(map['relatives']);

  toJson() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      "id": id,
      "fio": fio,
      "email": email,
      "phone": phone,
      "relatives": jsonEncode(relatives)
    };
  }
}
