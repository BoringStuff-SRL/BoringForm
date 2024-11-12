import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:rrule/rrule.dart';

@immutable
class RruleL10nIt extends RruleL10n {
  const RruleL10nIt();

  static Future<RruleL10nIt> create() async {
    await initializeDateFormatting('it');
    return const RruleL10nIt();
  }

  @override
  String get locale => 'it_IT';

  @override
  String frequencyInterval(Frequency frequency, int interval) {
    String plurals({required String one, required String plural}) {
      return switch (interval) {
        1 => one,
        _ => 'Ogni $interval $plural',
      };
    }

    return {
      Frequency.secondly: plurals(one: 'Ogni secondo', plural: 'secondi'),
      Frequency.minutely: plurals(one: 'Ogni minuto', plural: 'minuti'),
      Frequency.hourly: plurals(one: 'Ogni ora', plural: 'ore'),
      Frequency.daily: plurals(one: 'Ogni giorno', plural: 'giorni'),
      Frequency.weekly: plurals(one: 'Ogni settimana', plural: 'settimane'),
      Frequency.monthly: plurals(one: 'Ogni mese', plural: 'mesi'),
      Frequency.yearly: plurals(one: 'Ogni anno', plural: 'anni'),
    }[frequency]!;
  }

  @override
  String until(DateTime until, Frequency frequency) {
    final untilString =
        formatWithIntl(() => DateFormat.yMMMMd('it_IT').format(until));
    return ', fino al $untilString';
  }

  @override
  String count(int count) {
    return switch (count) {
      1 => ', $count volta',
      _ => ', $count volte',
    };
  }

  ///////

  @override
  String onInstances(String instances) => 'al $instances istanza';

  @override
  String inMonths(String months, {InOnVariant variant = InOnVariant.simple}) =>
      '${_inVariant(variant)} $months';

  @override
  String inWeeks(String weeks, {InOnVariant variant = InOnVariant.simple}) =>
      '${_inVariant(variant)} la $weeks settimana dell\'anno';

  String _inVariant(InOnVariant variant) {
    return switch (variant) {
      InOnVariant.simple => 'di',
      InOnVariant.also => 'che sono anche nel',
      InOnVariant.instanceOf => 'di',
    };
  }

  @override
  String onDaysOfWeek(
    String days, {
    bool indicateFrequency = false,
    DaysOfWeekFrequency? frequency = DaysOfWeekFrequency.monthly,
    InOnVariant variant = InOnVariant.simple,
  }) {
    if (days.contains("giorni feriali")) {
      return "nei $days";
    }
    return 'di $days';
  }

  @override
  String? get weekdaysString => 'giorni feriali';
  @override
  String get everyXDaysOfWeekPrefix => 'ogni ';
  @override
  String nthDaysOfWeek(Iterable<int> occurrences, String daysOfWeek) {
    if (occurrences.isEmpty) return daysOfWeek;

    final ordinals = list(
      occurrences.map(ordinal).toList(),
      ListCombination.conjunctiveShort,
    );
    return 'il $ordinals $daysOfWeek';
  }

  @override
  String onDaysOfMonth(
    String days, {
    DaysOfVariant daysOfVariant = DaysOfVariant.simple,
    InOnVariant variant = InOnVariant.simple,
  }) {
    final suffix = {
      DaysOfVariant.simple: '',
      DaysOfVariant.day: ' giorno',
      DaysOfVariant.dayAndFrequency: ' del mese',
    }[daysOfVariant];

    return '${_onVariant(variant)} ${days.replaceAll("°", "")}$suffix';
  }

  @override
  String onDaysOfYear(
    String days, {
    InOnVariant variant = InOnVariant.simple,
  }) =>
      '${_onVariant(variant)} il $days giorno dell\'anno';

  String _onVariant(InOnVariant variant) {
    return switch (variant) {
      InOnVariant.simple => 'il giorno',
      InOnVariant.also => 'che sono anche',
      InOnVariant.instanceOf => 'di',
    };
  }

  @override
  String list(List<String> items, ListCombination combination) {
    final days = [
      "lunedì",
      "martedì",
      "mercoledì",
      "giovedì",
      "venerdì",
      "sabato",
      "domenica",
    ];

    final result = items
        .map(
          (e) {
            const ch = "–";

            if (e.contains(ch)) {
              final split = e.split(ch).map((e) => e.trim()).toList();
              final startIndex = days.indexOf(split.first);
              final endIndex = days.indexOf(split.last);

              return days.getRange(startIndex, endIndex + 1);
            }
            return [e];
          },
        )
        .expand((element) => element)
        .toList();

    if (result.length <= 1) {
      return result.first;
    }

    return "${result.sublist(0, result.length - 1).join(", ")} e ${result.last}";
  }

  @override
  String ordinal(int number) {
    assert(number != 0);
    if (number == -1) return 'ultimo';

    final n = number.abs();
    final string = '$n°';

    return number < 0 ? '$string all\'ultimo' : string;
  }
}
