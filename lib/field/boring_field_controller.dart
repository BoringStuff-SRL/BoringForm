import 'package:flutter/widgets.dart';

enum ChangedEvent { valueChanged, sumbittedForValidation }

enum ValidationType { always, onSubmit }

class BoringFieldController<T> extends ChangeNotifier {
  BoringFieldController({this.initialValue, this.validationFunction})
      : _value = initialValue;

  BoringFieldController<T> copyWith(
          {T? initialValue, String? Function(T? value)? validationFunction}) =>
      BoringFieldController(
          initialValue: initialValue ?? this.initialValue,
          validationFunction: validationFunction ?? this.validationFunction);

  T? _value;
  T? initialValue;
  String? Function(T? value)? validationFunction;

  T? get value => _value;
  set value(T? newValue) {
    setValueSilently(newValue);
    notifyListeners();
  }

  String? get errorMessage => validationFunction?.call(_value);

  void setValueSilently(T? newValue) {
    _value = newValue;
  }

  void sendNotification() => notifyListeners();

  bool get isValid => errorMessage == null;

  void reset() {
    _value = initialValue;
    notifyListeners();
  }
}
