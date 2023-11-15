import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

enum ChangedEvent { valueChanged, sumbittedForValidation }

enum ValidationType { always, onSubmit }

class BoringFieldController<T> extends ChangeNotifier {
  BoringFieldController(
      {T? initialValue, this.validationFunction, this.autoValidate = false})
      : _initialValue = initialValue,
        _value = initialValue;

  BoringFieldController.withValue(
      {T? initialValue,
      this.validationFunction,
      required T? value,
      this.autoValidate = false})
      : _initialValue = initialValue,
        _value = value;

  BoringFieldController<T> copyWith(
      {T? initialValue,
      String? Function(T? value)? validationFunction,
      T? value}) {
    return BoringFieldController.withValue(
        value: value ?? _value,
        initialValue: initialValue ?? this.initialValue,
        validationFunction: validationFunction ?? this.validationFunction);
  }

  T? _value;
  T? _initialValue;

  void Function()? onReset;
  String? Function(T? value)? validationFunction;
  final ValueNotifier<bool> hideError = ValueNotifier(true);

  T? get value {
    if (_value != null && _value is String) {
      return (_value as String).trim() as T;
    }

    return _value;
  }

  bool autoValidate;

  bool get changed => !const DeepCollectionEquality().equals(
        _fromEmptyStringToNull(value as Map),
        _merge(
          _initialValue == null ? {} : _initialValue as Map,
          _removeValue(value as Map),
        ),
      );

  // Prende from e lo merge-a dentro into, mantenendo sempre la stessa struttura
  Map _merge(Map from, Map into) {
    Map result = {};
    into.forEach((key, value) {
      if (from.containsKey(key)) {
        if (value is Map) {
          result.addEntries({key: _merge(from[key], into[key])}.entries);
        } else {
          result.addEntries({key: from[key]}.entries);
        }
      } else {
        result.addEntries({key: value}.entries);
      }
    });
    return result;
  }

  // Se esiste una chiave qualsiasi all'interno della mappa con valore ''
  // allora quel valore diventera' null
  Map _fromEmptyStringToNull(Map data) {
    Map result = {};
    data.forEach((key, value) {
      if (value is String && value == '') {
        result.addEntries({key: null}.entries);
      } else if (value is Map) {
        result.addEntries({key: _fromEmptyStringToNull(data[key])}.entries);
      } else if (value is List) {
        List<Map> maps = [];
        for (var element in value) {
          if (element is Map) {
            maps.add(_fromEmptyStringToNull(element));
          }
        }
        result.addEntries({key: maps}.entries);
      } else {
        result.addEntries({key: value}.entries);
      }
    });
    return result;
  }

  // Data una mappa, imposta tutti i valori degli elementi a null
  Map _removeValue(Map data) {
    Map result = {};
    data.forEach((key, value) {
      if (value is Map) {
        result.addEntries({key: _removeValue(value)}.entries);
      } else if (value is List) {
        List<Map> maps = [];
        for (var element in value) {
          if (element is Map) {
            maps.add(_removeValue(element));
          }
        }
        result.addEntries({key: maps}.entries);
      } else {
        result.addEntries({key: null}.entries);
      }
    });
    return result;
  }

  set value(T? newValue) {
    setValueSilently(newValue);
    notifyListeners();
  }

  T? get initialValue => _initialValue;

  set initialValue(T? val) {
    _initialValue = val;
  }

  String? get errorMessage {
    return validationFunction?.call(_value);
  }

  void setValueSilently(T? newValue) {
    _value = newValue;
  }

  void sendNotification() => notifyListeners();

  bool get isValid {
    hideError.value = errorMessage == null;
    return errorMessage == null;
  }

  void reset() {
    _value = initialValue;
    onReset?.call();
    notifyListeners();
  }
}
