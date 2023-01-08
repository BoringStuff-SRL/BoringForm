import 'package:boring_form/boring_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FieldsListProvider extends ChangeNotifier {
  List<BoringField> _fields = [];

  List<BoringField> get fields => _fields;

  set fields(List<BoringField> fields) {
    Set<String> oldKeys = _fields.map((e) => e.jsonKey).toSet();
    Set<String> newKeys = fields.map((e) => e.jsonKey).toSet();
    if (!setEquals(oldKeys, newKeys)) {
      _fields = fields;
      notifyListeners();
    }
  }
}
