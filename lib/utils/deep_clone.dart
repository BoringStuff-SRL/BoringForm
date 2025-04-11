// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:rrule/rrule.dart';

class ObjectExtensions {
  static T deepClone<T>(T object,
      {List<ObjectConverter<T>> converters = const []}) {
    if (object is Map) {
      var copy = (object).deepClone(converters: converters);

      if (object is Map<String, dynamic>) {
        return copy.map((k, v) => MapEntry(k.toString(), v)) as T;
      }

      return copy as T;
    }
    if (object is List) {
      return (object as List).deepClone(converters: converters) as T;
    }
    if (object is Set) {
      return (object as Set).deepClone(converters: converters) as T;
    }

    // return converter?.call(object) ?? object;
    return converters.fold(object, (value, converter) => converter(value));
  }
}

extension MapCloneExtension<K, V> on Map<K, V> {
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
}

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
