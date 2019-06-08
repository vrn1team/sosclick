import 'package:flutter/material.dart';
import '../models/location_data.dart';

class Relative {
  final String id;
  final String fio;
  final String phone;
  final bool isPreferred;
  final String userEmail;
  final String userId;
  final LocationData location;

  Relative(
      {@required this.id,
      @required this.fio,
      @required this.phone,
      @required this.userEmail,
      @required this.userId,
      @required this.location,
      this.isPreferred = false});
}
