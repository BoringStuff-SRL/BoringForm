import 'package:boring_form/boring_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FieldsListProvider extends ChangeNotifier {
  final Map<String, bool> _fieldsOffStage = {};
  bool isFieldOnStage(BoringField field) =>
      !(_fieldsOffStage[field.jsonKey] ?? false);

  void notifyIfDifferentFields(
      List<BoringField> fields, Map<String, dynamic> map) {
    bool diff = false;
    for (var field in fields) {
      bool onStage = field.displayCondition?.call(map) ?? true;
      diff = diff || isFieldOnStage(field) != onStage;
      _fieldsOffStage[field.jsonKey] = !onStage;
    }
    if (diff) {
      notifyListeners();
    }
  }
}
