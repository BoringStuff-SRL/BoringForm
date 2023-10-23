import 'package:boring_form/implementations/pickers/boring_picker_field.dart';
import 'package:boring_form/utils/datetime_extnesions.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class BoringDateTimeField extends BoringPickerField<DateTime?> {
  BoringDateTimeField({
    super.key,
    super.fieldController,
    super.onChanged,
    required super.jsonKey,
    super.boringResponsiveSize,
    super.updateValueOnDismiss,
    super.displayCondition,
    super.decoration,
    super.readOnly,
    super.showEraseValueButton,
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  })  : assert(
            initialDate == null ||
                (initialDate <= lastDate && initialDate >= firstDate),
            "initial date must be between firstDate and lastDate"),
        super(
            showPicker: (context) async => await showOmniDateTimePicker(
                context: context,
                initialDate: DateTime.now(),
                is24HourMode: true,
                firstDate: firstDate,
                lastDate: lastDate,
                isForce2Digits: true),
            valueToString: (value) => value == null
                ? ''
                : "${dateTimeToString(value)}, ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}");
}

String dateTimeToString(DateTime? dt) =>
    dt != null ? "${dt.day}/${dt.month}/${dt.year}" : "";

DateTime middle(DateTime dt1, DateTime dt2, DateTime dt3) {
  if (dt1 < dt2) {
    if (dt2 < dt3) {
      return dt2;
    } else if (dt3 < dt1) {
      return dt1;
    } else {
      return dt3;
    }
  } else {
    if (dt1 < dt3) {
      return dt1;
    } else if (dt3 < dt2) {
      return dt2;
    } else {
      return dt3;
    }
  }
}

class BoringDateField extends BoringPickerField<DateTime?> {
  BoringDateField({
    super.key,
    super.fieldController,
    super.onChanged,
    required super.jsonKey,
    super.boringResponsiveSize,
    super.updateValueOnDismiss,
    super.displayCondition,
    super.decoration,
    super.readOnly,
    super.showEraseValueButton,
    DateTime? initialDate,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    required this.firstlDate,
    required this.lastDate,
  })  : assert(firstlDate <= lastDate, "firstDate must be less than lastDate"),
        assert(
            initialDate == null ||
                (initialDate <= lastDate && initialDate >= firstlDate),
            "initial date must be between firstDate and lastDate"),
        super(
            showPicker: (context) async => await showDatePicker(
                context: context,
                initialEntryMode: initialEntryMode,
                initialDate: fieldController?.value ??
                    initialDate ??
                    middle(firstlDate, DateTime.now(), lastDate),
                firstDate: firstlDate,
                lastDate: lastDate,
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                }),
            valueToString: dateTimeToString);
  final DateTime firstlDate, lastDate;
  final DatePickerEntryMode initialEntryMode;

  void initialDateAssertion(DateTime? initialDate) {
    assert(
        initialDate == null ||
            (initialDate < lastDate && initialDate > firstlDate),
        "initial date must be between firstDate and lastDate");
  }

  @override
  bool setInitialValue(DateTime? initialValue, [bool forceSet = false]) {
    initialDateAssertion(initialValue);
    return super.setInitialValue(initialValue);
  }
}

class BoringTimeField extends BoringPickerField<TimeOfDay?> {
  BoringTimeField({
    super.key,
    super.fieldController,
    super.onChanged,
    required super.jsonKey,
    this.initialEntryMode = TimePickerEntryMode.inputOnly,
    super.boringResponsiveSize,
    super.updateValueOnDismiss,
    super.displayCondition,
    super.decoration,
    super.readOnly,
    super.showEraseValueButton,
    TimeOfDay? initialTime,
  }) : super(
            showPicker: (context) async => await showTimePicker(
                context: context,
                initialEntryMode: initialEntryMode,
                initialTime: initialTime ?? TimeOfDay.now(),
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                }),
            valueToString: (value) => value == null
                ? ""
                : "${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}");

  final TimePickerEntryMode initialEntryMode;
}

//TODO showDateRangePicker ALSO INSIDE DIALOG (not only full screen)
class BoringDateRangeField extends BoringPickerField<DateTimeRange?> {
  BoringDateRangeField({
    super.key,
    super.fieldController,
    super.onChanged,
    super.readOnly,
    required super.jsonKey,
    super.boringResponsiveSize,
    super.updateValueOnDismiss,
    super.decoration,
    super.showEraseValueButton,
    super.displayCondition,
    required DateTime lastDate,
    required DateTime firstDate,
    DateTime? currentDate,
  }) : super(
            showPicker: (context) async {
              final dates = await showCalendarDatePicker2Dialog(
                context: context,
                config: CalendarDatePicker2WithActionButtonsConfig(
                    calendarType: CalendarDatePicker2Type.range,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    currentDate: currentDate),
                useSafeArea: true,
                useRootNavigator: true,
                dialogSize: Size(500, 1),
              );

              return dates != null
                  ? DateTimeRange(start: dates.first!, end: dates.last!)
                  : null;
            },
            valueToString: (value) => value == null
                ? ""
                : "${dateTimeToString(value.start)} - ${dateTimeToString(value.end)}");
}
