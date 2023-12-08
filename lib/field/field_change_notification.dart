import 'package:flutter/material.dart';

class FieldChangeNotification extends Notification {
  List<String> fieldJsonPath;
  FieldChangeNotification(this.fieldJsonPath)
      : assert(fieldJsonPath.isNotEmpty);
}
