import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

//enum ChangedEvent { valueChanged, sumbittedForValidation }

class MapKeyListException implements Exception {
  int _errorIndex;
  final List<String> _fullPath;

  MapKeyListException(List<String> pathKeys)
      : _fullPath = pathKeys,
        _errorIndex = 0;

  void pushFieldLeft(String key) {
    _fullPath.insert(0, key);
    _errorIndex += 1;
  }

  List<String> get errorPath => _fullPath.getRange(0, _errorIndex).toList();
  @override
  String toString() {
    return "Field at path $errorPath is not a Map. Requested field: $_fullPath";
  }
}

//enum ValidationType { always, onSubmit }
extension on Map<String, dynamic> {
  dynamic getValue(List<String> keysList) {
    if (keysList.isEmpty) {
      return null;
    }
    final key = keysList.first;
    if (!containsKey(key)) {
      return null;
    }
    final element = this[key];
    if (keysList.length == 1) {
      return element;
    }
    if (element is Map) {
      try {
        return (element as Map<String, dynamic>)
            .getValue(keysList.getRange(1, keysList.length).toList());
      } on MapKeyListException catch (e) {
        e.pushFieldLeft(key);
        rethrow;
      }
    }
    throw MapKeyListException(keysList);
  }

  void setValue(List<String> keysList, dynamic value) {
    if (keysList.isEmpty) {
      return;
    }
    final key = keysList.first;
    if (keysList.length == 1) {
      this[key] = value;
      return;
    }
    if (!containsKey(key)) {
      this[key] = {};
    }
    final element = this[key];
    if (element is Map) {
      try {
        (element as Map<String, dynamic>)
            .setValue(keysList.getRange(1, keysList.length).toList(), value);
      } on MapKeyListException catch (e) {
        e.pushFieldLeft(key);
        rethrow;
      }
    }
    throw MapKeyListException(keysList);
  }

  void mergeValue(Map<String, dynamic> map, [bool mergeSubMaps = false]) {
    if (!mergeSubMaps) {
      addAll(map);
    }
    //TODO
    throw UnimplementedError();
  }
}

class BoringFormControllerValue extends ChangeNotifier {
  final Map<String, dynamic> _value;
  final Map<String, dynamic> initialValue;

  static const DeepCollectionEquality _equality = DeepCollectionEquality();

  BoringFormControllerValue({this.initialValue = const {}})
      : _value = initialValue;

  dynamic getValue(List<String> fieldPath) => _value.getValue(fieldPath);

  List<dynamic> getMultiValues(List<List<String>> fieldPaths) =>
      fieldPaths.map((keysList) => _value.getValue(keysList)).toList();

  void setFieldValue(List<String> fieldPath, dynamic value) {
    dynamic old = _value.getValue(fieldPath);
    if (_equality.equals(old, value)) {
      return;
    }
    _value.setValue(fieldPath, value);
    notifyListeners();
  }

  set value(Map<String, dynamic> newValue) {
    if (_equality.equals(_value, newValue)) {
      return;
    }
    _value.clear();
    _value.addAll(newValue);
    notifyListeners();
  }

  Map<String, dynamic> get value => _value;

  void mergeValue(Map<String, dynamic> map, [bool mergeSubMaps = false]) =>
      _value.mergeValue(map, mergeSubMaps);
}

class BoringFormController extends BoringFormControllerValue {
  final Map<List<String>, String?> _errors = {};
  BoringFormController({super.initialValue});

  void reset() {
    value = initialValue;
  }

  bool get hasChanged =>
      !BoringFormControllerValue._equality.equals(_value, initialValue);

  void setFieldError(List<String> fieldPath, String? errror) {
    _errors[fieldPath] = errror;
  }

  bool get isValid => _errors.values.every((element) => element == null);
}
