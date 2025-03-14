import 'package:boring_form/form/bform_controller.dart';

// class DeferredValue<L extends Listenable, T> {
//   DeferredValue({
//     required this.listenable,
//     required this.selector,
//   });

//   final L listenable;
//   final AsyncValue<T> Function(L listenable) selector;

//   AsyncValue<T> get asyncValue => selector(listenable);

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is DeferredValue &&
//           runtimeType == other.runtimeType &&
//           listenable == other.listenable &&
//           selector == other.selector;

//   @override
//   int get hashCode => listenable.hashCode ^ selector.hashCode;
// }

//enum ChangedEvent { valueChanged, sumbittedForValidation }
enum ValidationBehaviour {
  always,
  onSubmit,
  never;
}

enum FieldRequiredLabelBehaviour {
  always,
  hiddenWhenValid,
  never;
}

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
// extension BFormFieldValueExt on Map<String, dynamic> {
//   bool pathExists(FieldPath path) {
//     return true;
//   }

//   dynamic getValue(List<String> keysList) {
//     if (keysList.isEmpty) {
//       return null;
//     }
//     final key = keysList.first;
//     if (!containsKey(key)) {
//       return null;
//     }
//     final element = this[key];
//     if (keysList.length == 1 || element == null) {
//       return element;
//     }
//     if (element is Map) {
//       try {
//         return (element as Map<String, dynamic>)
//             .getValue(keysList.getRange(1, keysList.length).toList());
//       } on MapKeyListException catch (e) {
//         e.pushFieldLeft(key);
//         rethrow;
//       }
//     }
//     throw MapKeyListException(keysList);
//   }

//   void setValue(List<String> keysList, dynamic value) {
//     if (keysList.isEmpty) {
//       return;
//     }
//     final key = keysList.first;
//     if (keysList.length == 1) {
//       this[key] = value;
//       return;
//     }
//     if (!containsKey(key) || this[key] == null) {
//       this[key] = <String, dynamic>{};
//     }
//     final element = this[key];
//     if (element is Map) {
//       try {
//         (element as Map<String, dynamic>)
//             .setValue(keysList.getRange(1, keysList.length).toList(), value);
//       } on MapKeyListException catch (e) {
//         e.pushFieldLeft(key);
//         rethrow;
//       }
//     } else {
//       throw MapKeyListException(keysList);
//     }
//   }

//   void mergeValue(Map<String, dynamic> map, [bool mergeSubMaps = false]) {
//     if (!mergeSubMaps) {
//       addAll(map);
//     }
//     //TODO
//     throw UnimplementedError();
//   }

//   void addEntry(MapEntry<String, dynamic> entry) {
//     this[entry.key] = entry.value;
//   }

//   Map<String, dynamic> plain(String nestingChar) {
//     final plainMap = <String, dynamic>{};
//     for (var entry in entries) {
//       if (entry.value is Map<String, dynamic>) {
//         final toAdd = (entry.value as Map<String, dynamic>).plain(nestingChar);
//         for (var newEntry in toAdd.entries) {
//           final newKey = "${entry.key}$nestingChar${newEntry.key}";
//           plainMap[newKey] = newEntry.value;
//         }
//       } else {
//         plainMap.addEntry(entry);
//       }
//     }
//     return plainMap;
//   }
// }

// class BoringFormControllerValue extends ChangeNotifier {
//   BoringFormControllerValue({
//     Map<FieldPath, DeferredValue>? deferredFields,
//     Map<String, dynamic>? initialValue,
//     Set<FieldPath>? readOnlyFields,
//     this.validationBehaviour = ValidationBehaviour.onSubmit,
//     this.fieldRequiredLabelBehaviour = FieldRequiredLabelBehaviour.always,
//   })  : _value = Map.from(initialValue ?? {}),
//         _deferredFields = deferredFields ?? {},
//         initialValue = Map.from(initialValue ?? {}),
//         _readOnlyFields = readOnlyFields ?? {};

//   static const NESTING_CHAR = '.';
//   static const DeepCollectionEquality _equality = DeepCollectionEquality();

//   final Map<String, dynamic> _value;
//   final Map<String, dynamic> initialValue;
//   final Map<FieldPath, DeferredValue> _deferredFields;
//   final Set<FieldPath> _readOnlyFields;
//   final Map<String, Map<FieldPath, void Function()>> _fieldsListener = {};

//   final ValidationBehaviour validationBehaviour;
//   final FieldRequiredLabelBehaviour fieldRequiredLabelBehaviour;

//   /// GETTERS
//   Map<FieldPath, DeferredValue> get deferredFields => _deferredFields;
//   Map<String, dynamic> get value => _value;
//   bool get hasChanged =>
//       !BoringFormControllerValue._equality.equals(_value, initialValue);
//   Map<String, dynamic> get valuePlain => _value.plain(NESTING_CHAR);

//   dynamic getValue(List<String> fieldPath, {dynamic defaultValue}) =>
//       _value.getValue(fieldPath) ?? defaultValue;

//   DeferredValue? getDeferredValue(FieldPath fieldPath) =>
//       _deferredFields.entries
//           .firstWhereOrNull((element) => listEquals(fieldPath, element.key))
//           ?.value;

//   dynamic getValuePlain(String fieldPath) =>
//       getValue(fieldPath.split(NESTING_CHAR));

//   /// SETTERS

//   void setFieldValuePlain(String fieldPath, dynamic value) =>
//       setFieldValue(fieldPath.split(NESTING_CHAR), value);

//   set value(Map<String, dynamic> newValue) {
//     if (_equality.equals(_value, newValue)) {
//       return;
//     }
//     _value.clear();
//     _value.addAll(newValue);
//     _fieldHasChanged([]);
//     notifyListeners();
//   }

//   void setFieldValue<R>(
//     List<String> fieldPath,
//     R value, {
//     bool notify = true,
//   }) {
//     dynamic old = _value.getValue(fieldPath);
//     if (_equality.equals(old, value)) {
//       return;
//     }

//     _value.setValue(fieldPath, value);
//     // print(_value);
//     _fieldHasChanged(fieldPath);
//     if (notify) notifyListeners();
//   }

//   /// PUBLIC METHODS

//   /// Note that this function won't work if the field has the readOnly param given
//   void setFieldReadOnlyStatus(
//     FieldPath path, {
//     required bool readOnly,
//     bool notify = true,
//   }) {
//     if (readOnly) {
//       _readOnlyFields.add(path);
//     } else {
//       _readOnlyFields.removeWhere((element) => listEquals(element, path));
//     }
//     if (notify) {
//       notifyListeners();
//     }
//   }

//   bool isFieldReadOnly(FieldPath fieldPath) => _readOnlyFields
//       .where((element) => listEquals(element, fieldPath))
//       .isNotEmpty;

//   void addFieldsListener({
//     required String key,
//     required List<FieldPath> fields,
//     required void Function() callback,
//   }) {
//     final Map<FieldPath, void Function()> map = {};
//     for (final field in fields) {
//       map[field] = callback;
//     }
//     _fieldsListener[key] = map;
//   }

//   void removeFieldsListener(String key) {
//     _fieldsListener.remove(key);
//   }

//   // void mergeValue(Map<String, dynamic> map, [bool mergeSubMaps = false]) =>
//   //     _value.mergeValue(map, mergeSubMaps);

//   void reset() {
//     value = initialValue;
//   }

//   void resetFields(List<List<String>> fieldPaths) {
//     for (var fieldPath in fieldPaths) {
//       setFieldValue(fieldPath, null);
//     }
//   }

//   /// PRIVATE METHODS

//   List<dynamic> _getMultiValues(List<List<String>> fieldPaths) =>
//       fieldPaths.map((keysList) => _value.getValue(keysList)).toList();

//   List<void Function()> _getFieldListeners(FieldPath path) {
//     return _fieldsListener.values
//         .expand((e) => e.entries)
//         .where(
//           (element) {
//             final fieldPath = element.key;
//             if (fieldPath.length > path.length) return false;

//             for (int i = 0; i < fieldPath.length; i++) {
//               if (fieldPath[i] != path[i]) return false;
//             }
//             return true;
//           },
//         )
//         .map((e) => e.value)
//         .toList();
//   }

//   void _fieldHasChanged(FieldPath path) {
//     final listeners = _getFieldListeners(path);
//     for (final callback in listeners) {
//       callback.call();
//     }
//   }

//   List<dynamic> _getMultiValuesPlain(List<String> fieldPaths) =>
//       _getMultiValues(fieldPaths.map((e) => e.split(NESTING_CHAR)).toList());

//   //TODO only `set value` and `void mergeValue` don't have a plain version
// }

typedef ValidationFunction<T> = String? Function(
    BoringFormController formController, T? value)?;
typedef FieldPath = List<String>;

// class BoringFormController extends BoringFormControllerValue {
//   BoringFormController({
//     super.deferredFields,
//     super.initialValue,
//     super.validationBehaviour,
//     super.fieldRequiredLabelBehaviour,
//   });

//   static BoringFormController of(BuildContext context) =>
//       context.read<BoringFormController>();

//   final Map<FieldPath, ValidationFunction> _validationFunctions = {};

//   bool get isValid {
//     final deferredLoading = _deferredFields.entries
//         .any((element) => element.value.asyncValue.isLoading);

//     if (deferredLoading) return false;

//     if (!_isSubmitted) {
//       _isSubmitted = true;
//       notifyListeners();
//     }
//     return _validationFunctions.entries.every(
//         (element) => element.value?.call(this, getValue(element.key)) == null);
//     //return _errors.values.every((element) => element == false);
//   }

//   List<List<String>> get fieldsNotValid {
//     return _validationFunctions.entries
//         .where((element) =>
//             (element.value?.call(this, getValue(element.key)) != null))
//         .map((e) => e.key)
//         .toList();
//   }

//   void setValidationFunction<T>(
//       FieldPath fieldPath, ValidationFunction<T>? validationFunction) {
//     _validationFunctions[fieldPath] = validationFunction != null
//         ? ((controller, val) => validationFunction(controller, val as T?))
//         : null;
//   }

//   void removeValidationFunction(FieldPath fieldPath) {
//     _validationFunctions.removeWhere(
//       (key, value) =>
//           BoringFormControllerValue._equality.equals(key, fieldPath),
//     );
//   }

//   String? getFieldError(FieldPath fieldPath) => _shouldShowError
//       ? _validationFunctions[fieldPath]?.call(this, getValue(fieldPath))
//       : null;

//   bool _isSubmitted = false;

//   bool get _shouldShowError =>
//       validationBehaviour == ValidationBehaviour.always ||
//       (validationBehaviour == ValidationBehaviour.onSubmit && _isSubmitted);

//   List<dynamic> selectPaths(
//           /*FieldPath fieldPath,*/ List<FieldPath> observedPaths,
//           {required bool includeError}) =>
//       [includeError && _shouldShowError, ..._getMultiValues(observedPaths)];
// }
