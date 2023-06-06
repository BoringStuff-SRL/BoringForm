import 'package:boring_form/implementations/pickers/boring_picker_field.dart';
import 'package:boring_form/utils/datetime_extnesions.dart';
import 'package:flutter/material.dart';

//TODO BoringDateTimeField
// class BoringDateTimeField extends BoringPickerField<TimeOfDay?> {
//   BoringDateTimeField(
//       {super.key,
//       required super.fieldController,
//       super.onChanged,
//       required super.jsonKey,
//       super.boringResponsiveSize,
//       super.decoration})
//       : super(
//             showPicker: (context) async => await showDate(
//                   context: context,
//                   initialTime: TimeOfDay.now(),
//                 ),
//             valueToString: (value) => value == null
//                 ? ""
//                 : "${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}");
// }

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
    DateTime? initialDate,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    required this.firstlDate,
    required this.lastDate,
  })  : assert(firstlDate < lastDate, "firstDate must be less than lastDate"),
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
                lastDate: lastDate),
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
    TimeOfDay? initialTime,
  }) : super(
            showPicker: (context) async => await showTimePicker(
                  context: context,
                  initialEntryMode: initialEntryMode,
                  initialTime: initialTime ?? TimeOfDay.now(),
                ),
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
    required super.jsonKey,
    super.boringResponsiveSize,
    super.updateValueOnDismiss,
    super.decoration,
    super.displayCondition,
    required DateTime lastDate,
    required DateTime firstDate,
  }) : super(
            showPicker: (context) async => await showDateRangePicker(
                  context: context,
                  lastDate: lastDate,
                  firstDate: firstDate,
                ),
            valueToString: (value) => value == null
                ? ""
                : "${dateTimeToString(value.start)} - ${dateTimeToString(value.end)}");
}
