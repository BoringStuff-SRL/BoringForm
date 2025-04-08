import 'package:boring_ui/boring_ui.dart';

extension BFormPathStartsWith<T> on Iterable<T> {
  bool startsWith(Iterable<T> other) {
    if (length < other.length) return false;
    for (int i = 0; i < other.length; i++) {
      if (elementAt(i) != other.elementAt(i)) return false;
    }
    return true;
  }
}

extension BFormFieldValueExt on Map<String, dynamic> {
  Map<String, dynamic> clone() => Map<String, dynamic>.from(_deepCopy(this));

  dynamic _deepCopy(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(
          value.map((key, val) => MapEntry(_deepCopy(key), _deepCopy(val))));
    } else if (value is List) {
      /// TODO: copy also the items in the list (code below doesn't work, throws exception)
      /// return value.map((item) => _deepCopy(item)).toList();
      return value.toList();
    } else {
      return value; // tipi primitivi o oggetti immutabili
    }
  }

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

  void removeKey(
    FieldPath keysList,
  ) {
    if (keysList.isEmpty) {
      return;
    }
    final key = keysList.first;
    if (keysList.length == 1) {
      remove(key);
      return;
    }
    final element = this[key];
    if (element is Map) {
      try {
        (element as Map<String, dynamic>)
            .removeKey(keysList.getRange(1, keysList.length).toList());
      } catch (e) {}
    } else {
      return;
    }
  }

  void addEntry(MapEntry<String, dynamic> entry) => addEntries([entry]);
}

extension EmptyMap<K, V> on Map<K, V> {
  bool get isEmptyInside =>
      entries.isEmpty ||
      entries.every((entry) =>
          entry.value == null ||
          (entry.value is Map && (entry.value as Map).isEmptyInside) ||
          (entry.value is Iterable && (entry.value as Iterable).isEmptyInside));
}

extension EmptyIterable<T> on Iterable<T> {
  bool get isEmptyInside =>
      isEmpty ||
      every((element) =>
          element == null ||
          (element is Map && element.isEmptyInside) ||
          (element is Iterable && (element.isEmptyInside)));
}

extension SetExtension<T> on Set<T> {
  bool containsAny(Iterable<T> elements) => elements.any(contains);
}

/// Function that provides dynamic extensions based on current form values
///
/// IMPORTANT: When implementing this function, you must use `controller.value` or
/// `controller.getFormValue(removeHidden: false)` to avoid infinite recursion loops.
/// Never call `controller.getFormValue()` with default parameters inside this function.
typedef DynamicExtensionsFunction = List<BFormExtension> Function(
    BFormController controller, Map<String, dynamic> value);
