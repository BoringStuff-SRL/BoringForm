import 'package:boring_form/form/form_value_extensions.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef FieldValidation = ({
  String? error,
  bool showError,
  bool showRequiredLabel,
  bool isReadOnly,
});

class BFormController extends ChangeNotifier {
  static const DeepCollectionEquality _equality = DeepCollectionEquality();
  static BFormController of(BuildContext context) =>
      BFormControllerProvider.controllerOf(context);

  final Map<String, dynamic> _value;
  final Map<String, dynamic> _initialValue;

  final Map<FieldPath, ValidationFunction> _validationFunctions = {};

  final ValidationBehaviour validationBehaviour;
  final FieldRequiredLabelBehaviour fieldRequiredLabelBehaviour;

  final DynamicExtensionsFunction? _extensions;

  BFormController({
    Map<String, dynamic>? initialValue,
    Set<FieldPath>? readOnlyFields,
    this.validationBehaviour = ValidationBehaviour.onSubmit,
    this.fieldRequiredLabelBehaviour = FieldRequiredLabelBehaviour.always,
    DynamicExtensionsFunction? extensions,
  })  : _value = Map.from(initialValue ?? {}),
        _initialValue = Map.from(initialValue ?? {}),
        _extensions = extensions {
    _computedExtensions = _extensions?.call(this, _value);
  }

  //[START] ASYNC LOGIC
  final Set<FieldPath> _loadingFields = {};
  final Set<FieldPath> _errorFields = {};

  @protected
  void setLoadingField(FieldPath fieldPath) {
    var notify = false;
    notify = _loadingFields.add(fieldPath) || notify;
    notify = _errorFields.remove(fieldPath) || notify;
    if (notify) {
      asyncNotifyListeners();
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
    List<FieldPath>? pathsToObserve,
  ) {
    final observedPaths = pathsToObserve;
    if (observedPaths != null && observedPaths.isEmpty) {
      return const AsyncValueDone({});
    }
    final loading = observedPaths != null
        ? observedPaths.any(_isPathLoading)
        : _loadingFields.isNotEmpty;
    if (loading) return const AsyncValueLoading();
    final error = observedPaths != null
        ? observedPaths.any(_isPathAsyncError)
        : _errorFields.isNotEmpty;
    if (error) {
      return const AsyncValueError(Object());
    }
    return AsyncValueDone(
      Map.fromEntries(
        (observedPaths ?? []).map(
          (path) => MapEntry(path, value.getValue(path)),
        ),
      ),
    );
  }

  bool _isPathLoading(FieldPath fieldPath) =>
      _loadingFields.any((path) => path.startsWith(fieldPath));

  bool _isPathAsyncError(FieldPath fieldPath) =>
      _errorFields.any((path) => path.startsWith(fieldPath));

  // static Set<FieldPath> allPaths(Map<String, dynamic> value) {
  //   Set<FieldPath> result = {};
  //   // ignore: no_leading_underscores_for_local_identifiers
  //   void _collectPaths(Map<String, dynamic> map, FieldPath currentPath) {
  //     for (var entry in map.entries) {
  //       final path = [...currentPath, entry.key];
  //       if (entry.value is Map<String, dynamic>) {
  //         _collectPaths(entry.value as Map<String, dynamic>, path);
  //       } else {
  //         result.add(path);
  //       }
  //     }
  //   }
  //   _collectPaths(value, []);
  //   return result;
  // }

  //[END] ASYNC LOGIC

  final Map<String, Map<FieldPath, void Function()>> _fieldsListener = {};

  /// GETTERS

  List<BFormExtension>? _computedExtensions;

  ///
  /// Returns the current value of the form.
  Map<String, dynamic> get value => getFormValue();

  // /// Returns the current value of the form.
  // ///
  // /// When [removeIgnored] is true (default), fields marked with [BIgnoreField] will be removed.

  // ///
  // /// WARNING: If you're implementing the [DynamicExtensionsFunction] parameter of the constructor,
  // /// you MUST set [removeHidden] to false or use the [value] getter instead to avoid infinite loops.
  Map<String, dynamic> getFormValue({
    bool removeIgnored = true,
  }) {
    final val = Map<String, dynamic>.from(_value);
    if (!removeIgnored) return val;

    for (final ext in _getIgnoreFieldsExtensions) {
      val.removeKey(ext.fieldPath);
    }
    return val;
  }

  dynamic getValue(List<String> fieldPath) =>
      getFormValue().getValue(fieldPath);

  List<dynamic> getValues(List<List<String>> fieldPaths) =>
      fieldPaths.map(getValue).toList();

  bool get hasChanged =>
      !BFormController._equality.equals(value, _initialValue);

  Map<String, dynamic>? submit() {
    if (!_submitted) {
      _submitted = true;
      notifyListeners();
    }
    return isValid ? value : null;
  }

  String? Function(BFormController, dynamic)? _getFieldValidationFunction(
      FieldPath fieldPath) {
    return _validationFunctions.entries
        .where((e) => fieldPath.startsWith(e.key))
        .map((e) => e.value)
        .firstOrNull;
  }

  Iterable<({FieldPath fieldPath, String error})> _getFieldsValidationErrors(
      [List<FieldPath>? paths]) {
    final errorsIterator = switch (paths == null) {
      true => _validationFunctions.entries
            .where((entry) => !isFieldRemoved(entry.key))
            .map((entry) {
          final path = entry.key;
          final error = entry.value?.call(this, getValue(path));
          return (fieldPath: path, error: error);
        }),
      false => (paths ?? []).where((path) => !isFieldRemoved(path)).map((path) {
          final error =
              _getFieldValidationFunction(path)?.call(this, getValue(path));
          return (fieldPath: path, error: error);
        }),
    };
    return errorsIterator.where((element) => element.error != null).map(
          (element) => (fieldPath: element.fieldPath, error: element.error!),
        );
  }

  Iterable<({FieldPath fieldPath, String error})> _getExtensionsErrors(
      [List<FieldPath>? paths]) {
    return _getValidationExtensions
        .where((ext) {
          if (paths == null) return true;

          return paths.any((path) => ext.attachedPaths
              .any((attacchedPath) => path.startsWith(attacchedPath)));
        })
        .map((ext) => MapEntry(
            ext.attachedPaths, ext.validationFunction?.call(this, _value)))
        .map<Iterable<MapEntry<FieldPath, String?>>>((ext) {
          if (ext.key.isEmpty) {
            return [MapEntry([], ext.value)];
          }
          return ext.key.map((path) => MapEntry(path, ext.value));
        })
        .expand((e) => e)
        .where((e) => e.value != null)
        .map((e) => (fieldPath: e.key, error: e.value!))
        .where((element) => !isFieldRemoved(element.fieldPath));
  }

  Iterable<({FieldPath fieldPath, String error})> errors(
      [List<FieldPath>? paths]) {
    return _getFieldsValidationErrors(paths)
        .followedBy(_getExtensionsErrors(paths));
  }

  // Iterable<({FieldPath fieldPath, String error})> get errors =>
  //     _validationFunctions.entries
  //         .map((e) => (fieldPath: e.key, error: validateField(e.key)))
  //         .where((element) => element.error != null)
  //         .map((element) =>
  //             (fieldPath: element.fieldPath, error: element.error!));

  bool get isValid {
    // final paths = allPaths(_value);
    if (_loadingFields.isNotEmpty || _errorFields.isNotEmpty) {
      return false;
    }
    return errors().isEmpty;
  }

  /// SETTERS

  void reset() {
    value = _initialValue;
  }

  set value(Map<String, dynamic> newValue) {
    if (_equality.equals(_value, newValue)) {
      return;
    }
    _value.clear();
    _value.addAll(newValue);
    notifyListeners();
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

    // _fieldHasChanged(fieldPath);
    if (notify) {
      notifyListeners();
    }
    return true;
  }

  //CONTROLLER LOGIC
  bool _submitted = false;

  String? validateField(FieldPath fieldPath) =>
      errors([fieldPath]).firstOrNull?.error;

  @protected
  void setValidationFunction<T>(
      FieldPath fieldPath, ValidationFunction<T>? validationFunction) {
    _validationFunctions[fieldPath] = validationFunction != null
        ? ((controller, val) => validationFunction(controller, val as T?))
        : null;
  }

  @protected
  FieldValidation selectFieldValidation(FieldPath fieldPath,
      {required bool fieldMarkedReadonly, required bool fieldRequired}) {
    final errror = validateField(fieldPath);
    final showError = errror != null &&
        validationBehaviour != ValidationBehaviour.never &&
        (_submitted || validationBehaviour == ValidationBehaviour.always);

    final shouldShowRequiredLabel = switch (fieldRequiredLabelBehaviour) {
      FieldRequiredLabelBehaviour.always => fieldRequired,
      FieldRequiredLabelBehaviour.hiddenWhenValid => errror != null,
      FieldRequiredLabelBehaviour.never => false,
    };
    final showRequiredLabel =
        !isFieldRemoved(fieldPath) && shouldShowRequiredLabel;
    final isReadOnly = fieldMarkedReadonly || isFieldReadOnly(fieldPath);

    return (
      error: errror,
      showError: showError,
      showRequiredLabel: showRequiredLabel,
      isReadOnly: isReadOnly
    );
  }

  ({T value, FieldValidation validation, bool isHidden}) selectField<T>(
      FieldPath fieldPath,
      {required bool fieldMarkedReadonly,
      required bool fieldRequired}) {
    final value = getValue(fieldPath);
    final hidden = isFieldHidden(fieldPath);

    final validation = selectFieldValidation(fieldPath,
        fieldMarkedReadonly: fieldMarkedReadonly, fieldRequired: fieldRequired);
    return (value: value, validation: validation, isHidden: hidden);
  }

  //EXTENSIONS

  final List<BIgnoreField> _ignoreFieldsExtensions = [];
  final List<BComputedField> _computedFieldsExtensions = [];
  final Map<String, BValidation> _validationExtensions = {};

  List<BIgnoreField> get _getIgnoreFieldsExtensions {
    return (_computedExtensions ?? [])
        .whereType<BIgnoreField>()
        .where(
          (extension) => !_ignoreFieldsExtensions.any(
            (fixedExt) => extension.fieldPath.startsWith(fixedExt.fieldPath),
          ),
        )
        .followedBy(_ignoreFieldsExtensions)
        .toList();
  }

  List<BComputedField> get _getComputedFieldsExtensions {
    return (_computedExtensions ?? [])
        .whereType<BComputedField>()
        .where(
          (e) => !_computedFieldsExtensions.any(
            (fixedExt) => e.fieldPath.startsWith(fixedExt.fieldPath),
          ),
        )
        .followedBy(_computedFieldsExtensions)
        .toList();
  }

  List<BValidation> get _getValidationExtensions {
    return (_computedExtensions ?? [])
        .whereType<BValidation>()
        .followedBy(_validationExtensions.values)
        .toList();
  }

  bool isFieldReadOnly(FieldPath fieldPath) =>
      isFieldRemoved(fieldPath) ||
      _getComputedFieldsExtensions.any(
          (e) => listEquals(e.fieldPath, fieldPath) && !e.allowFieldChanges);

  bool isFieldRemoved(FieldPath fieldPath) => _getIgnoreFieldsExtensions.any(
        (e) => fieldPath.startsWith(e.fieldPath),
      );
  bool isFieldHidden(FieldPath fieldPath) => _getIgnoreFieldsExtensions.any(
        (e) => fieldPath.startsWith(e.fieldPath) && e.hideField,
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

  void setIgnoreField(BIgnoreField extension, {bool setFieldToNull = false}) {
    _ignoreFieldsExtensions
        .removeWhere((e) => listEquals(e.fieldPath, extension.fieldPath));
    _ignoreFieldsExtensions.add(extension);
    if (setFieldToNull) {
      setFieldValue(extension.fieldPath, null, notify: false);
    }
    notifyListeners();
  }

  void removeIgnoreField(BIgnoreField extension) {
    _ignoreFieldsExtensions
        .removeWhere((e) => listEquals(e.fieldPath, extension.fieldPath));
    notifyListeners();
  }

  bool hasIgnoreFieldExtension(FieldPath fieldPath) =>
      _ignoreFieldsExtensions.any((e) => listEquals(e.fieldPath, fieldPath));

  @override
  void notifyListeners() {
    for (var cf in _getComputedFieldsExtensions) {
      final value = cf.compute(this);
      setFieldValue(cf.fieldPath, value, notify: false);
    }
    _computedExtensions = _extensions?.call(this, _value);
    super.notifyListeners();
  }

  void asyncNotifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // void printValidations(FieldPath fieldPath) {
  //   final f = _getFieldValidationFunction(fieldPath);
  //   print(
  //     'Validations for $fieldPath: ${f?.toString() ?? 'null'}',
  //   );
  //   final v = getValue(fieldPath);
  //   print('Value for $fieldPath: ${v?.toString() ?? 'null'}');
  //   final err = f?.call(this, v);
  //   print('Error for $fieldPath: ${err?.toString() ?? 'null'}');
  // }
}

sealed class BFormExtension {}

class BComputedField<T> extends BFormExtension {
  final FieldPath fieldPath;
  final T Function(BFormController formController) compute;
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

  BIgnoreField({
    required this.fieldPath,
    this.hideField = true,
  });

  @override
  String toString() {
    return 'BIgnoreField{fieldPath: $fieldPath, hideField: $hideField}';
  }
}

class BValidation extends BFormExtension {
  final ValidationFunction validationFunction;
  final List<FieldPath> attachedPaths;
  BValidation({
    this.attachedPaths = const [],
    required this.validationFunction,
  });
}
