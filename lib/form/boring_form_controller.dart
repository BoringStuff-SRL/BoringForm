import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension<T> on Iterable<T> {
  bool startsWith(Iterable<T> other) {
    if (length < other.length) return false;
    for (int i = 0; i < other.length; i++) {
      if (elementAt(i) != other.elementAt(i)) return false;
    }
    return true;
  }
}

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

  void addEntry(MapEntry<String, dynamic> entry) => addEntries([entry]);
}

typedef FieldValidation = ({
  String? error,
  bool showError,
  bool showRequiredLabel,
  bool isReadOnly,
});

extension SetExtension<T> on Set<T> {
  bool containsAny(Iterable<T> elements) => elements.any(contains);
}

class BoringFormController extends ChangeNotifier {
  static const DeepCollectionEquality _equality = DeepCollectionEquality();
  static BoringFormController of(BuildContext context) =>
      BFormControllerProvider.controllerOf(context);

  final Map<String, dynamic> _value;
  final Map<String, dynamic> _initialValue;
  final Set<FieldPath> _readOnlyFields;
  final Map<FieldPath, DeferredValue> _deferredFields;

  final Map<FieldPath, ValidationFunction> _validationFunctions = {};

  final ValidationBehaviour validationBehaviour;
  final FieldRequiredLabelBehaviour fieldRequiredLabelBehaviour;

  BoringFormController({
    Map<String, dynamic>? initialValue,
    Set<FieldPath>? readOnlyFields,
    Map<FieldPath, DeferredValue>? deferredFields,
    this.validationBehaviour = ValidationBehaviour.onSubmit,
    this.fieldRequiredLabelBehaviour = FieldRequiredLabelBehaviour.always,
  })  : _value = Map.from(initialValue ?? {}),
        _initialValue = Map.from(initialValue ?? {}),
        _readOnlyFields = readOnlyFields ?? {},
        _deferredFields = deferredFields ?? {};

  //[START] ASYNC LOGIC
  final Set<FieldPath> _loadingFields = {};
  final Set<FieldPath> _errorFields = {};

  @protected
  void setLoadingField(FieldPath fieldPath) {
    var notify = false;
    notify = _loadingFields.add(fieldPath) || notify;
    notify = _errorFields.remove(fieldPath) || notify;
    if (notify) {
      notifyListeners();
    }
  }

  @protected
  void setErrorField(FieldPath fieldPath) {
    var notify = false;
    notify = _errorFields.add(fieldPath) || notify;
    notify = _loadingFields.remove(fieldPath) || notify;
    if (notify) {
      notifyListeners();
    }
  }

  @protected
  void setDoneField(FieldPath fieldPath) {
    var notify = false;
    notify = _errorFields.remove(fieldPath) || notify;
    notify = _loadingFields.remove(fieldPath) || notify;
    if (notify) {
      notifyListeners();
    }
  }

  @protected
  AsyncValue<Map<FieldPath, dynamic>> observed(
      List<FieldPath>? pathsToObserve) {
    final observedPaths = pathsToObserve ?? allPaths(_value);
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

  static Set<FieldPath> allPaths(Map<String, dynamic> value) {
    Set<FieldPath> result = {};
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

    _collectPaths(value, []);
    return result;
  }

  //[END] ASYNC LOGIC

  final Map<String, Map<FieldPath, void Function()>> _fieldsListener = {};

  /// GETTERS
  Map<FieldPath, DeferredValue> get deferredFields => _deferredFields;
  Map<String, dynamic> get value => _value;
  bool get hasChanged =>
      !BoringFormController._equality.equals(_value, _initialValue);

  DeferredValue? getDeferredValue(FieldPath fieldPath) =>
      _deferredFields.entries
          .firstWhereOrNull((element) => listEquals(fieldPath, element.key))
          ?.value;

  bool get isValid {
    final deferredLoading = _deferredFields.entries
        .any((element) => element.value.asyncValue.isLoading);

    if (deferredLoading) return false;

    if (!submitted) {
      submitted = true;
      notifyListeners();
    }

    final paths = allPaths(_value);
    for (final path in paths) {
      if (_loadingFields.contains(path)) return false;
    }

    return _validationFunctions.entries.every(
        (element) => element.value?.call(this, getValue(element.key)) == null);
  }

  dynamic getValue(List<String> fieldPath, {dynamic defaultValue}) =>
      _value.getValue(fieldPath) ?? defaultValue;

  List<dynamic> getValues(List<List<String>> fieldPaths) =>
      fieldPaths.map((keysList) => _value.getValue(keysList)).toList();

  /// SETTERS

  void reset() {
    value = _initialValue;
  }

  set value(Map<String, dynamic> newValue) {
    if (_equality.equals(_value, newValue)) {
      return;
    }
    final newPaths = allPaths(newValue);
    final oldPaths = allPaths(_value);
    final pathsToSetNull = oldPaths.difference(newPaths);
    var shouldNotify = false;
    for (final path in pathsToSetNull) {
      shouldNotify = setFieldValue(path, null, notify: false) || shouldNotify;
    }
    for (final path in newPaths) {
      final val = newValue.getValue(path);
      shouldNotify = setFieldValue(path, val, notify: false) || shouldNotify;
    }
    if (shouldNotify) {
      notifyListeners();
    }
  }

  bool setFieldValue<R>(
    List<String> fieldPath,
    R? value, {
    bool notify = true,
  }) {
    dynamic old = _value.getValue(fieldPath);
    if (_equality.equals(old, value)) {
      return false;
    }
    _value.setValue(fieldPath, value);
    // print(_value);
    // _fieldHasChanged(fieldPath);
    if (notify) notifyListeners();
    return true;
  }

  /// PUBLIC METHODS

  /// Note that this function won't work if the field has the readOnly param given
  // void setFieldReadOnlyStatus(
  //   FieldPath path, {
  //   required bool readOnly,
  //   bool notify = true,
  // }) {
  //   if (readOnly) {
  //     _readOnlyFields.add(path);
  //   } else {
  //     _readOnlyFields.removeWhere((element) => listEquals(element, path));
  //   }
  //   if (notify) {
  //     notifyListeners();
  //   }
  // }

  // bool isFieldReadOnly(FieldPath fieldPath) => _readOnlyFields
  //     .where((element) => listEquals(element, fieldPath))
  //     .isNotEmpty;

  // void addFieldsListener({
  //   required String key,
  //   required List<FieldPath> fields,
  //   required void Function() callback,
  // }) {
  //   final Map<FieldPath, void Function()> map = {};
  //   for (final field in fields) {
  //     map[field] = callback;
  //   }
  //   _fieldsListener[key] = map;
  // }

  // void removeFieldsListener(String key) {
  //   _fieldsListener.remove(key);
  // }

  // void resetFields(List<List<String>> fieldPaths) {
  //   for (var fieldPath in fieldPaths) {
  //     setFieldValue(fieldPath, null);
  //   }
  // }

  /// PRIVATE METHODS

  // List<dynamic> _getMultiValues(List<List<String>> fieldPaths) =>
  //     fieldPaths.map((keysList) => _value.getValue(keysList)).toList();

  // void _fieldHasChanged(FieldPath path) {
  //   _fieldsListener.values
  //       .expand((e) => e.entries)
  //       .where(
  //         (element) {
  //           final fieldPath = element.key;
  //           if (fieldPath.length > path.length) return false;

  //           for (int i = 0; i < fieldPath.length; i++) {
  //             if (fieldPath[i] != path[i]) return false;
  //           }
  //           return true;
  //         },
  //       )
  //       .map((e) => e.value)
  //       .forEach((callback) => callback());
  // }

  //CONTROLLER LOGIC
  bool submitted = false;

  void setValidationFunction<T>(
      FieldPath fieldPath, ValidationFunction<T>? validationFunction) {
    _validationFunctions[fieldPath] = validationFunction != null
        ? ((controller, val) => validationFunction(controller, val as T?))
        : null;
  }

  String? _fieldValidation(FieldPath fieldPath) {
    final validationFunction = _validationFunctions[fieldPath];
    if (isFieldRemoved(fieldPath)) return null;
    return validationFunction?.call(this, getValue(fieldPath));
  }

  String? validateField(FieldPath fieldPath) =>
      _fieldValidation(fieldPath) ?? _fieldValidationExtension(fieldPath);

  FieldValidation selectFieldValidation(FieldPath fieldPath,
      {required bool fieldMarkedReadonly}) {
    final errror = validateField(fieldPath);
    final showError = errror != null &&
        validationBehaviour != ValidationBehaviour.never &&
        (submitted || validationBehaviour == ValidationBehaviour.always);
    final showRequiredLabel =
        fieldRequiredLabelBehaviour == FieldRequiredLabelBehaviour.always ||
            (fieldRequiredLabelBehaviour ==
                    FieldRequiredLabelBehaviour.hiddenWhenValid &&
                errror != null);
    final isReadOnly = fieldMarkedReadonly || isFieldReadOnly(fieldPath);

    return (
      error: errror,
      showError: showError,
      showRequiredLabel: showRequiredLabel,
      isReadOnly: isReadOnly
    );
  }

  ({T value, FieldValidation validation}) selectField<T>(FieldPath fieldPath,
      {required bool fieldMarkedReadonly}) {
    final value = getValue(fieldPath);
    final validation = selectFieldValidation(fieldPath,
        fieldMarkedReadonly: fieldMarkedReadonly);
    return (value: value, validation: validation);
  }

  //EXTENSIONS
  final List<BIgnoreField> _ignoreFieldsExtensions = [];
  final List<BComputedField> _computedFieldsExtensions = [];
  final Map<String, BValidation> _validationExtensions = {};

  bool isFieldReadOnly(FieldPath fieldPath) =>
      isFieldRemoved(fieldPath) ||
      _computedFieldsExtensions.any(
          (e) => listEquals(e.fieldPath, fieldPath) && !e.allowFieldChanges);

  String? _fieldValidationExtension(FieldPath fieldPath) {
    final validation = _validationExtensions.values
        .firstWhereOrNull((e) => e.attachedPaths.contains(fieldPath));
    return validation?.validationFunction?.call(this, getValue(fieldPath));
  }

  bool isFieldRemoved(FieldPath fieldPath) => _ignoreFieldsExtensions.any(
        (e) =>
            listEquals(e.fieldPath, fieldPath) ||
            (e.includeSubFields && fieldPath.startsWith(e.fieldPath)),
      );

  void setValidationExtension(BValidation extension, String key) {
    _validationExtensions[key] = extension;
    notifyListeners();
  }

  void removeValidationExtension(String key) {
    _validationExtensions.remove(key);
    notifyListeners();
  }

  bool hasValidationExtension(String key) =>
      _validationExtensions.containsKey(key);

  void setComputedField(BComputedField extension) {
    _computedFieldsExtensions
        .removeWhere((e) => listEquals(e.fieldPath, extension.fieldPath));
    _computedFieldsExtensions.add(extension);
    notifyListeners();
  }

  void removeComputedField(BComputedField extension) {
    _computedFieldsExtensions
        .removeWhere((e) => listEquals(e.fieldPath, extension.fieldPath));
    notifyListeners();
  }

  bool hasComputedFieldExtension(FieldPath fieldPath) =>
      _computedFieldsExtensions.any((e) => listEquals(e.fieldPath, fieldPath));

  void setIgnoreField(BIgnoreField extension) {
    _ignoreFieldsExtensions
        .removeWhere((e) => listEquals(e.fieldPath, extension.fieldPath));
    _ignoreFieldsExtensions.add(extension);
    notifyListeners();
  }

  void removeIgnoreField(BIgnoreField extension) {
    _ignoreFieldsExtensions
        .removeWhere((e) => listEquals(e.fieldPath, extension.fieldPath));
    notifyListeners();
  }

  bool hasIgnoreFieldExtension(FieldPath fieldPath) =>
      _ignoreFieldsExtensions.any((e) => listEquals(e.fieldPath, fieldPath));

  List<BFormExtension> get extensions => [
        ..._computedFieldsExtensions,
        ..._ignoreFieldsExtensions,
        ..._validationExtensions.values
      ];
}

sealed class BFormExtension {}

class BComputedField<T> extends BFormExtension {
  final FieldPath fieldPath;
  final T Function(BoringFormController formController) compute;
  final bool allowFieldChanges;
  BComputedField({
    required this.fieldPath,
    required this.compute,
    this.allowFieldChanges = false,
  });
}

class BIgnoreField extends BFormExtension {
  final FieldPath fieldPath;
  final bool hideField;
  final bool includeSubFields;
  BIgnoreField({
    required this.fieldPath,
    this.hideField = true,
    this.includeSubFields = true,
  });
}

class BValidation extends BFormExtension {
  final ValidationFunction validationFunction;
  final List<FieldPath> attachedPaths;
  BValidation({
    this.attachedPaths = const [],
    required this.validationFunction,
  });
}
