import 'package:boring_ui/boring_ui.dart';

class BoringDurationDataHandler {
  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;

  const BoringDurationDataHandler({
    required this.years,
    required this.months,
    required this.days,
    required this.hours,
    required this.minutes,
  });

  String? readableString(BDurationFieldTheme durationTheme) {
    if (inDuration.inSeconds == 0) return null;

    final yearsString =
        '$years ${durationTheme.yearsString(years).toLowerCase()}';
    final monthsString =
        '$months ${durationTheme.monthsString(months).toLowerCase()}';
    final daysString = '$days ${durationTheme.daysString(days).toLowerCase()}';
    final hoursString =
        '$hours ${durationTheme.hoursString(hours).toLowerCase()}';
    final minutesString =
        '$minutes ${durationTheme.minutesString(minutes).toLowerCase()}';

    String result = '';

    if (years != 0) {
      result += '$yearsString ';
    }
    if (months != 0) {
      result += '$monthsString ';
    }
    if (days != 0) {
      result += '$daysString ';
    }
    if (hours != 0) {
      result += '$hoursString ';
    }
    if (minutes != 0) {
      result += minutesString;
    }
    return result;
  }

  static const oneDayInSeconds = 86400;
  static const oneHourInSeconds = 3600;
  static const oneMinuteInSeconds = 60;
  static int get oneYearInSeconds => (365 * oneDayInSeconds);
  static int get oneMonthInSeconds => (30 * oneDayInSeconds);

  Duration get inDuration {
    final minutesInSeconds = minutes * oneMinuteInSeconds;
    final hoursInSeconds = hours * oneHourInSeconds;
    final daysInSeconds = days * oneDayInSeconds;
    final monthsInSeconds = months * oneMonthInSeconds;
    final yearsInSeconds = years * oneYearInSeconds;

    final result = minutesInSeconds +
        hoursInSeconds +
        daysInSeconds +
        monthsInSeconds +
        yearsInSeconds;

    return Duration(seconds: result);
  }

  Map<String, dynamic> toMap() {
    return {
      'years': years == 0 ? null : years,
      'months': months == 0 ? null : months,
      'days': days == 0 ? null : days,
      'hours': hours == 0 ? null : hours,
      'minutes': minutes == 0 ? null : minutes,
    };
  }

  factory BoringDurationDataHandler.fromDuration(Duration duration) {
    int durationInSeconds = duration.inSeconds;

    final years =
        durationInSeconds ~/ BoringDurationDataHandler.oneYearInSeconds;

    /// tolgo la durata degli anni appena calcolati
    durationInSeconds = durationInSeconds -
        (years * BoringDurationDataHandler.oneYearInSeconds);

    final months =
        durationInSeconds ~/ BoringDurationDataHandler.oneMonthInSeconds;

    /// tolgo la durata dei mesi appena calcolati
    durationInSeconds = durationInSeconds -
        (months * BoringDurationDataHandler.oneMonthInSeconds);

    final days = durationInSeconds ~/ BoringDurationDataHandler.oneDayInSeconds;

    /// tolgo la durata dei giorni appena calcolati
    durationInSeconds =
        durationInSeconds - (days * BoringDurationDataHandler.oneDayInSeconds);

    final hours =
        durationInSeconds ~/ BoringDurationDataHandler.oneHourInSeconds;

    /// tolgo la durata delle ore appena calcolate
    durationInSeconds = durationInSeconds -
        (hours * BoringDurationDataHandler.oneHourInSeconds);

    final minutes =
        durationInSeconds ~/ BoringDurationDataHandler.oneMinuteInSeconds;

    return BoringDurationDataHandler(
      years: years,
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
    );
  }

  factory BoringDurationDataHandler.fromMap(Map<String, dynamic> map) {
    return BoringDurationDataHandler(
      years: map['years'] as int? ?? 0,
      months: map['months'] as int? ?? 0,
      days: map['days'] as int? ?? 0,
      hours: map['hours'] as int? ?? 0,
      minutes: map['minutes'] as int? ?? 0,
    );
  }
}
