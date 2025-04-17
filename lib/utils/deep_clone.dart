// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:rrule/rrule.dart';

extension MapDeepClone<K, V> on Map<K, V> {
  Map<K, V> toMap() => Map<K, V>.of(this);
}

extension DeepCopySet<T> on Set<T> {
  Set<T> deepClone({List<ObjectConverter<dynamic>> converters = const []}) {
    return map((item) => _deepCloneValue(item, converters: converters))
        .toSet()
        .cast<T>();
  }
}

extension DeepCopyMap<K, V> on Map<K, V> {
  Map<K, V> deepClone({List<ObjectConverter<dynamic>> converters = const []}) {
    return map((key, value) => MapEntry(
          _deepCloneValue(key, converters: converters),
          _deepCloneValue(value, converters: converters),
        ));
  }
}

extension DeepCopyList<T> on List<T> {
  List<T> deepClone({List<ObjectConverter<dynamic>> converters = const []}) {
    return map((item) => _deepCloneValue(item, converters: converters)).toList()
        as List<T>;
  }
}

// Funzione di supporto che gestisce il deep copy dei vari tipi
dynamic _deepCloneValue(
  dynamic value, {
  List<ObjectConverter<dynamic>> converters = const [],
}) {
  if (value is Map<String, dynamic>) {
    final copy = value.toMap();
    final clone = value.deepClone(converters: converters);
    copy.clear();
    for (final el in clone.entries) {
      copy[el.key] = el.value;
    }
    return copy;
  }

  if (value is Map) {
    final copy = value.toMap();
    final clone = value.deepClone(converters: converters);
    copy.clear();
    for (final el in clone.entries) {
      copy[el.key] = el.value;
    }
    return copy;
  }
  if (value is List) {
    final copy = value.toList();
    copy.clear();

    final clone = value.deepClone(converters: converters);

    for (final el in clone) {
      copy.add(el);
    }
    return copy;
  }

  return converters.fold(value, (value, converter) => converter(value));
}

/*
extension DeepCloneExtension on dynamic {
  /// Creates a deep copy of the object.
  /// Handles Maps, Lists, Sets, and primitive types.
  /// Applies converters for custom serialization or type handling.
  dynamic deepClone({List<ObjectConverter<dynamic>> converters = const []}) {
    final object = this; // Use 'object' locally for clarity, refers to 'this'
    // Handle null
    if (object == null) {
      return null;
    }

    // Handle collections
    if (object is Map) {
      // Clone Map
      final newMap = object.toMap();
      final copy = newMap.toMap();

      for (final copied in copy.entries) {
        final key = (copied.key as Object?).deepClone(converters: converters);

        final value =
            (copied.value as Object?).deepClone(converters: converters);
        newMap[key] = value;
      }

      return newMap;
    }
    if (object is List) {
      final newList = object.toList();

      final copy = newList.toList();
      newList.clear();
      for (final copied in copy) {
        newList.add((copied as Object?).deepClone(converters: converters));
      }

      return newList;
    }
    if (object is Set) {
      final newSet = object.toSet();
      final copy = newSet.toSet();
      newSet.clear();
      for (final copied in copy) {
        newSet.add((copied as Object?).deepClone(converters: converters));
      }

      return newSet;
    }
    // Apply converters for non-collection types or custom objects
    // The initial value for fold is the object itself.
    // Converters transform it sequentially.
    return converters.fold(object, (value, converter) => converter(value));
  }
}
*/

/*extension MapCloneExtension<K, V> on Map<K, V> {
  Map<K, V> deepClone({List<ObjectConverter<V>> converters = const []}) {
    return map((k, v) =>
        MapEntry(k, ObjectExtensions.deepClone(v, converters: converters)));
  }
}

extension ListCloneExtension<T> on List<T> {
  List<T> deepClone({List<ObjectConverter<T>> converters = const []}) {
    return map((e) => ObjectExtensions.deepClone(e, converters: converters))
        .toList();
  }
}

extension SetCloneExtension<T> on Set<T> {
  Set<T> deepClone({List<ObjectConverter<T>> converters = const []}) {
    return map((e) => ObjectExtensions.deepClone(e, converters: converters))
        .toSet();
  }
}*/

abstract class ObjectConverter<T> {
  dynamic call(T value);
}

class DefaultConverter<T> extends ObjectConverter<T> {
  dynamic Function(dynamic value)? convert;
  DefaultConverter({
    this.convert,
  });

  @override
  dynamic call(T value) {
    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    }
    if (value is String && value.trim().isEmpty) {
      return null;
    }

    if (value is Duration) {
      return "${value.inSeconds}";
    }

    if (value is RecurrenceRule) {
      return value.toString(
          options: RecurrenceRuleToStringOptions(isTimeUtc: true));
    }

    return convert != null ? convert!(value) : value;
  }
}
