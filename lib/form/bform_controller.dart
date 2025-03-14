import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension BFormFieldValueExt on Map<String, dynamic> {
  bool pathExists(FieldPath path) {
    return true;
  }

  dynamic getValue(FieldPath fieldPath) {
    if (fieldPath.isEmpty) {
      return null;
    }
    final key = fieldPath.first;
    if (!containsKey(key)) {
      return null;
    }
    final element = this[key];
    if (fieldPath.length == 1 || element == null) {
      return element;
    }
    if (element is Map) {
      try {
        return (element as Map<String, dynamic>)
            .getValue(fieldPath.skip(1).toList());
      } on MapKeyListException catch (e) {
        e.pushFieldLeft(key);
        rethrow;
      }
    }
    throw MapKeyListException(fieldPath);
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
    if (!containsKey(key) || this[key] == null) {
      this[key] = <String, dynamic>{};
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
    } else {
      throw MapKeyListException(keysList);
    }
  }

  void mergeValue(Map<String, dynamic> map, [bool mergeSubMaps = false]) {
    if (!mergeSubMaps) {
      addAll(map);
    }
    //TODO
    throw UnimplementedError();
  }

  void addEntry(MapEntry<String, dynamic> entry) => addEntries([entry]);
}

typedef FieldValidation = ({
  String? error,
  bool showError,
  bool showRequiredLabel
});

extension SetExtension<T> on Set<T> {
  bool containsAny(List<T> elements) => elements.any(contains);
}

class BFormController extends ChangeNotifier {
  static const DeepCollectionEquality _equality = DeepCollectionEquality();
  static BFormController of(BuildContext context) =>
      BFormControllerProvider.controllerOf(context);

  final Map<String, dynamic> _value;
  final Map<String, dynamic> _initialValue;
  final Set<FieldPath> _readOnlyFields;
  final Map<FieldPath, ValidationFunction> _validationFunctions = {};

  final ValidationBehaviour validationBehaviour;
  final FieldRequiredLabelBehaviour fieldRequiredLabelBehaviour;

  BFormController({
    Map<String, dynamic>? initialValue,
    Set<FieldPath>? readOnlyFields,
    this.validationBehaviour = ValidationBehaviour.onSubmit,
    this.fieldRequiredLabelBehaviour = FieldRequiredLabelBehaviour.always,
  })  : _value = Map.from(initialValue ?? {}),
        _initialValue = Map.from(initialValue ?? {}),
        _readOnlyFields = readOnlyFields ?? {};

  //[START] ASYNC LOGIC
  final Set<FieldPath> _loadingFields = {};
  final Set<FieldPath> _errorFields = {};

  void setLoadingField(FieldPath fieldPath) {
    var notify = false;
    notify = _loadingFields.add(fieldPath) || notify;
    notify = _errorFields.remove(fieldPath) || notify;
    if (notify) {
      notifyListeners();
    }
  }

  void setErrorField(FieldPath fieldPath) {
    var notify = false;
    notify = _errorFields.add(fieldPath) || notify;
    notify = _loadingFields.remove(fieldPath) || notify;
    if (notify) {
      notifyListeners();
    }
  }

  void setDoneField(FieldPath fieldPath) {
    var notify = false;
    notify = _errorFields.remove(fieldPath) || notify;
    notify = _loadingFields.remove(fieldPath) || notify;
    if (notify) {
      notifyListeners();
    }
  }

  AsyncValue<Map<FieldPath, dynamic>> observed(
      List<FieldPath>? pathsToObserve) {
    final observedPaths = pathsToObserve ?? allPaths();
    if (observedPaths.isEmpty) {
      return const AsyncValueDone({});
    }
    if (_loadingFields.containsAny(observedPaths)) {
      return const AsyncValueLoading();
    }
    if (_errorFields.containsAny(observedPaths)) {
      return const AsyncValueError(Object());
    }

    return AsyncValueDone(
      Map.fromEntries(
        observedPaths.map(
          (path) => MapEntry(path, _value.getValue(path)),
        ),
      ),
    );
  }

  List<FieldPath> allPaths() {
    List<FieldPath> result = [];
    // ignore: no_leading_underscores_for_local_identifiers
    void _collectPaths(Map<String, dynamic> map, FieldPath currentPath) {
      for (var entry in map.entries) {
        final path = [...currentPath, entry.key];
        if (entry.value is Map<String, dynamic>) {
          _collectPaths(entry.value as Map<String, dynamic>, path);
        } else {
          result.add(path);
        }
      }
    }

    _collectPaths(_value, []);
    return result;
  }

  //[END] ASYNC LOGIC

  final Map<String, Map<FieldPath, void Function()>> _fieldsListener = {};

  /// GETTERS
  Map<String, dynamic> get value => _value;
  bool get hasChanged =>
      !BFormController._equality.equals(_value, _initialValue);

  dynamic getValue(List<String> fieldPath, {dynamic defaultValue}) =>
      _value.getValue(fieldPath) ?? defaultValue;

  List<dynamic> getValues(List<List<String>> fieldPaths) =>
      fieldPaths.map((keysList) => _value.getValue(keysList)).toList();

  /// SETTERS

  set value(Map<String, dynamic> newValue) {
    if (_equality.equals(_value, newValue)) {
      return;
    }
    _value.clear();
    _value.addAll(newValue);
    _fieldHasChanged([]);
    notifyListeners();
  }

  void setFieldValue<R>(
    List<String> fieldPath,
    R value, {
    bool notify = true,
  }) {
    dynamic old = _value.getValue(fieldPath);
    if (_equality.equals(old, value)) {
      return;
    }

    _value.setValue(fieldPath, value);
    // print(_value);
    _fieldHasChanged(fieldPath);
    if (notify) notifyListeners();
  }

  /// PUBLIC METHODS

  /// Note that this function won't work if the field has the readOnly param given
  void setFieldReadOnlyStatus(
    FieldPath path, {
    required bool readOnly,
    bool notify = true,
  }) {
    if (readOnly) {
      _readOnlyFields.add(path);
    } else {
      _readOnlyFields.removeWhere((element) => listEquals(element, path));
    }
    if (notify) {
      notifyListeners();
    }
  }

  bool isFieldReadOnly(FieldPath fieldPath) => _readOnlyFields
      .where((element) => listEquals(element, fieldPath))
      .isNotEmpty;

  void addFieldsListener({
    required String key,
    required List<FieldPath> fields,
    required void Function() callback,
  }) {
    final Map<FieldPath, void Function()> map = {};
    for (final field in fields) {
      map[field] = callback;
    }
    _fieldsListener[key] = map;
  }

  void removeFieldsListener(String key) {
    _fieldsListener.remove(key);
  }

  void reset() {
    value = _initialValue;
  }

  void resetFields(List<List<String>> fieldPaths) {
    for (var fieldPath in fieldPaths) {
      setFieldValue(fieldPath, null);
    }
  }

  /// PRIVATE METHODS

  // List<dynamic> _getMultiValues(List<List<String>> fieldPaths) =>
  //     fieldPaths.map((keysList) => _value.getValue(keysList)).toList();

  void _fieldHasChanged(FieldPath path) {
    _fieldsListener.values
        .expand((e) => e.entries)
        .where(
          (element) {
            final fieldPath = element.key;
            if (fieldPath.length > path.length) return false;

            for (int i = 0; i < fieldPath.length; i++) {
              if (fieldPath[i] != path[i]) return false;
            }
            return true;
          },
        )
        .map((e) => e.value)
        .forEach((callback) => callback());
  }

  //CONTROLLER LOGIC
  bool submitted = false;

  void setValidationFunction<T>(
      FieldPath fieldPath, ValidationFunction<T>? validationFunction) {
    _validationFunctions[fieldPath] = validationFunction != null
        ? ((controller, val) => validationFunction(controller, val as T?))
        : null;
  }

  String? validateField(FieldPath fieldPath) {
    final validationFunction = _validationFunctions[fieldPath];
    if (validationFunction == null) return null;
    final value = getValue(fieldPath);
    return validationFunction(this, value);
  }

  FieldValidation selectFieldValidation(FieldPath fieldPath) {
    final errror = validateField(fieldPath);
    final showError = errror != null &&
        validationBehaviour != ValidationBehaviour.never &&
        (submitted || validationBehaviour == ValidationBehaviour.always);
    final showRequiredLabel =
        fieldRequiredLabelBehaviour == FieldRequiredLabelBehaviour.always ||
            (fieldRequiredLabelBehaviour ==
                    FieldRequiredLabelBehaviour.hiddenWhenValid &&
                errror != null);
    return (
      error: errror,
      showError: showError,
      showRequiredLabel: showRequiredLabel
    );
  }

  ({T value, FieldValidation validation}) selectField<T>(FieldPath fieldPath) {
    final value = getValue(fieldPath);
    final validation = selectFieldValidation(fieldPath);
    return (value: value, validation: validation);
  }

  void removeValidationFunction(FieldPath fieldPath) {
    _validationFunctions.removeWhere(
      (key, value) => BFormController._equality.equals(key, fieldPath),
    );
  }
}
