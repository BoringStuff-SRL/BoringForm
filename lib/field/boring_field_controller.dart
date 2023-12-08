import 'package:boring_form/fields_group.dart/boring_fields_group.dart';
import 'package:flutter/widgets.dart';

enum ChangedEvent { valueChanged, sumbittedForValidation }

enum ValidationType { always, onSubmit, never }

extension on List<String> {
  bool isSuperSet(List<String> list) {
    if (length < list.length) {
      return false;
    }
    for (var i = 0; i < length; i++) {
      if (this[i].trim() != list[i].trim()) {
        return false;
      }
    }
    return true;
  }
}

abstract class BoringFieldControllerInterface<T> extends ChangeNotifier {
  T? _value;
  final T? initialValue;

  BoringFieldControllerInterface({
    this.initialValue,
  }) : _value = initialValue;

  // final List<List<String>> observedFields = [];
  final List<List<String>> observedFields = [];

  bool _isChildOfAnchestor(List<String> changedField, int index) =>
      index >= 0 &&
      index < changedField.length &&
      changedField[index] == fieldJsonKey;

  bool _isFieldObserved(List<String> field) =>
      observedFields.any((element) => element.isSuperSet(field));

  void groupChangedNotification(List<String> changedField, int index) {
    if (_isChildOfAnchestor(changedField, index) &&
        index == changedField.length - 1) {
      //I WAS THE CHANGED ONE :)
      return;
    }
    //check if it was listening for changes on that specific field
    if (_isFieldObserved(changedField)) {
      notifyListeners();
    }
  }

  Function(List<String>)? notifyParent;
  String? fieldJsonKey;

  void setParentNotifier(Function(List<String>)? callback, String jsonKey) {
    if (notifyParent != null) {
      throw Exception("notifyParent can be assigned only once!");
    }
    notifyParent = callback;
    fieldJsonKey = jsonKey;
  }

  T? get value;
  set value(T? newValue);

  void _notify() {
    notifyListeners();
    if (notifyParent != null && fieldJsonKey != null) {
      notifyParent?.call([fieldJsonKey ?? ""]);
    }
  }
}

class BoringFieldController<T> extends BoringFieldControllerInterface<T> {
  @override
  T? get value {
    if (_value != null && _value is String) {
      if ((_value as String).isEmpty) {
        return null as T;
      }
      return (_value as String).trim() as T;
    }
    return _value;
  }

  @override
  set value(T? newValue) {
    //TODO check the equality operation
    if (_value != newValue) {
      _value = newValue;
      _notify();
    }
  }
}

class BoringFieldsGroupController
    extends BoringFieldControllerInterface<Map<String, dynamic>> {
  final Map<String, BoringFieldControllerInterface> _subControllers = {};

  void onFieldChanged(List<String> fieldPath) {
    final fullFieldPath = [fieldJsonKey!, ...fieldPath];
    if (notifyParent != null && fieldJsonKey != null) {
      //PROPAGATE THE CHANGE TO THE PARENT
      notifyParent?.call(fullFieldPath);
    } else {
      //NOTIFY ALL CHILDREN (except the direct one)
      for (var element in _subControllers.entries) {
        element.value.groupChangedNotification(fullFieldPath, 0);
      }
    }
  }

  @override
  void groupChangedNotification(List<String> changedField, int index) {
    //NOTIFY ALL CHILDREN (except the direct one)
    //IF THE TREE IS NOT CORRECT; THE INDEX SHOULD BE -1
    final int newIndex;
    if (_isChildOfAnchestor(changedField, index)) {
      newIndex = index + 1;
    } else {
      newIndex = -1;
    }
    for (var fieldController in _subControllers.values) {
      fieldController.groupChangedNotification(changedField, newIndex);
    }
  }

  void addSubController(
      BoringFieldControllerInterface fieldController, String jsonKey) {
    if (jsonKey != IGNORE_JSON_KEY) {
      _subControllers[jsonKey] = fieldController;
      fieldController.setParentNotifier(onFieldChanged, jsonKey);
    }
  }

  @override
  Map<String, dynamic> get value {
    final Map<String, dynamic> value = {};
    for (var entry in _subControllers.entries) {
      if (entry.key != IGNORE_JSON_KEY) {
        value[entry.key] = entry.value.value;
      }
    }
    return value;
  }

  @override
  set value(Map<String, dynamic>? newValue) {
    //TODO check the equality operation
    if (_value != newValue) {
      _value = newValue;
      _notify();
    }
  }
}


// class BoringFieldController<T> extends ValueNotifier<T?> {
//   T? _value;
//   T? initialValue;
//   Function(T?)? _changeCallback;

//   BuildContext? _fieldContext; //TODO non nullable late
//   // void Function()? onReset;
//   final String? Function(T? value)? validationFunction;
//   final bool autoValidate;
//   final ValueNotifier<bool> hideError = ValueNotifier(true);
//   BoringFieldController(
//       {this.initialValue, this.validationFunction, this.autoValidate = false})
//       : _value = initialValue,
//         super(initialValue);

//   // BoringFieldController.withValue(
//   //     {T? initialValue,
//   //     this.validationFunction,
//   //     required T? value,
//   //     this.autoValidate = false})
//   //     : _initialValue = initialValue,
//   //       _value = value;

//   // BoringFieldController<T> copyWith(
//   //     {T? initialValue,
//   //     String? Function(T? value)? validationFunction,
//   //     T? value}) {
//   //   return BoringFieldController.withValue(
//   //       value: value ?? _value,
//   //       initialValue: initialValue ?? this.initialValue,
//   //       validationFunction: validationFunction ?? this.validationFunction);
//   // }

//   void hasChangedValue(List<String> changedField) {
//     //check if was'n listening for changes on that specific field
//     if (false) {
//       return;
//     }
//     notifyListeners();
//   }

//   @override
//   T? get value {
//     if (_value != null && _value is String) {
//       if ((_value as String).isEmpty) {
//         return null as T;
//       }
//       return (_value as String).trim() as T;
//     }
//     return _value;
//   }

//   void notify() {
//     _changeCallback?.call(_value);
//     notifyListeners();
//   }

//   @override
//   set value(T? newValue) {
//     setValueSilently(newValue);
//     notify();
//   }

//   set changeCallback(Function(T?) callback) {
//     _changeCallback = callback;
//   }

//   set fieldContext(BuildContext context) {
//     _fieldContext = context;
//   }

//   String? get errorMessage => validationFunction?.call(_value);

//   bool get isValid {
//     hideError.value = errorMessage == null;
//     return errorMessage == null;
//   }

//   void setValueSilently(T? newValue) {
//     _value = newValue;
//   }

//   // bool get changed => !const DeepCollectionEquality().equals(
//   //       _fromEmptyStringToNull(value as Map),
//   //       _merge(
//   //         initialValue == null ? {} : initialValue as Map,
//   //         _removeValue(value as Map),
//   //       ),
//   //     );

//   // // Prende from e lo merge-a dentro into, mantenendo sempre la stessa struttura
//   // Map _merge(Map from, Map into) {
//   //   Map result = {};
//   //   into.forEach((key, value) {
//   //     if (from.containsKey(key)) {
//   //       if (value is Map) {
//   //         result.addEntries({key: _merge(from[key], into[key])}.entries);
//   //       } else {
//   //         result.addEntries({key: from[key]}.entries);
//   //       }
//   //     } else {
//   //       result.addEntries({key: value}.entries);
//   //     }
//   //   });
//   //   return result;
//   // }

//   // Se esiste una chiave qualsiasi all'interno della mappa con valore ''
//   // allora quel valore diventera' null
//   // Map _fromEmptyStringToNull(Map data) {
//   //   Map result = {};
//   //   data.forEach((key, value) {
//   //     if (value is String && value == '') {
//   //       result.addEntries({key: null}.entries);
//   //     } else if (value is Map) {
//   //       result.addEntries({key: _fromEmptyStringToNull(data[key])}.entries);
//   //     } else if (value is List) {
//   //       List<Map> maps = [];
//   //       for (var element in value) {
//   //         if (element is Map) {
//   //           maps.add(_fromEmptyStringToNull(element));
//   //         }
//   //       }
//   //       result.addEntries({key: maps}.entries);
//   //     } else {
//   //       result.addEntries({key: value}.entries);
//   //     }
//   //   });
//   //   return result;
//   // }

//   // Data una mappa, imposta tutti i valori degli elementi a null
//   // Map _removeValue(Map data) {
//   //   Map result = {};
//   //   data.forEach((key, value) {
//   //     if (value is Map) {
//   //       result.addEntries({key: _removeValue(value)}.entries);
//   //     } else if (value is List) {
//   //       List<Map> maps = [];
//   //       for (var element in value) {
//   //         if (element is Map) {
//   //           maps.add(_removeValue(element));
//   //         }
//   //       }
//   //       result.addEntries({key: maps}.entries);
//   //     } else {
//   //       result.addEntries({key: null}.entries);
//   //     }
//   //   });
//   //   return result;
//   // }

//   // void sendNotification() => notifyListeners();

//   void reset() {
//     _value = initialValue;
//     // onReset?.call();
//     notify();
//   }
// }
