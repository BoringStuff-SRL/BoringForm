import 'package:boring_form/boring_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FieldsListProvider extends ChangeNotifier {
  final Map<String, bool> _fieldsOffStage = {};

  bool isFieldOnStage(BoringField field) =>
      !(_fieldsOffStage[field.jsonKey] ?? false);

  Set<String> notifyIfDifferentFields(
      List<BoringField> fields, Map<String, dynamic> map) {
    bool diff = false;
    Set<String> hiddenFieldsKeys = {};
    for (var field in fields) {
      bool onStage = field.displayCondition?.call(map) ?? true;
      if (!onStage) {
        hiddenFieldsKeys.add(field.jsonKey);
      }
      diff = diff || isFieldOnStage(field) != onStage;
      _fieldsOffStage[field.jsonKey] = !onStage;
    }
    if (diff) {
      notifyListeners();
    }
    return hiddenFieldsKeys;
  }
}
