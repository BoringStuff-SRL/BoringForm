import 'package:boring_form/field/boring_field_controller.dart';
import 'package:flutter/widgets.dart';

//enum ChangedEvent { valueChanged, sumbittedForValidation }

//enum ValidationType { always, onSubmit }

class BoringFormController extends BoringFieldController<Map<String, dynamic>> {
  BoringFormController({super.initialValue, super.validationFunction}) {
    initValues();
  }

  void initValues() {}

  Map<String, BoringFieldController> subControllers = {};

  Set<String> ignoreFields = {};

  @override
  Map<String, dynamic>? get value =>
      subControllers.map((key, value) => MapEntry(key, value.value))
        ..removeWhere((key, value) => ignoreFields.contains(key));

  @override
  set value(Map<String, dynamic>? newValue) {
    super.value = newValue;
    for (var key in subControllers.keys) {
      if (newValue?.containsKey(key) ?? false) {
        subControllers[key]?.value = newValue![key];
      } else {
        subControllers[key]?.value = null;
      }
    }
  }

  bool _allSubControllersValid() => !((Map.from(subControllers)
        ..removeWhere((key, value) => ignoreFields.contains(key)))
      .values
      .any((element) => !element.isValid));

  @override
  bool get isValid => errorMessage == null && _allSubControllersValid();

  @override
  void reset() {
    super.reset();
    for (var controller in subControllers.values) {
      controller.reset();
    }
    notifyListeners();
  }
}
