import 'package:boring_form/form/boring_form_controller.dart';

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

typedef ValidationFunction<T> = String? Function(
    BFormController formController, T? value)?;
typedef FieldPath = List<String>;
