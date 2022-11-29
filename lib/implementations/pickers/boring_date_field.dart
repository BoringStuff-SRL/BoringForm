import 'package:boring_form/field/boring_field_controller.dart';
import 'package:boring_form/implementations/pickers/boring_picker_field.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_form/field/boring_field.dart';
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

class BoringDateField extends BoringPickerField<DateTime?> {
  BoringDateField(
      {super.key,
      required super.fieldController,
      super.onChanged,
      required super.jsonKey,
      super.boringResponsiveSize,
      super.updateValueOnDismiss,
      super.decoration})
      : super(
            showPicker: (context) async => await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2022),
                lastDate: DateTime(2023)),
            valueToString: dateTimeToString);
}

class BoringTimeField extends BoringPickerField<TimeOfDay?> {
  BoringTimeField(
      {super.key,
      required super.fieldController,
      super.onChanged,
      required super.jsonKey,
      super.boringResponsiveSize,
      super.updateValueOnDismiss,
      super.decoration})
      : super(
            showPicker: (context) async => await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ),
            valueToString: (value) => value == null
                ? ""
                : "${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}");
}

//TODO showDateRangePicker ALSO INSIDE DIALOG (not only full screen)
class BoringDateRangeField extends BoringPickerField<DateTimeRange?> {
  BoringDateRangeField(
      {super.key,
      required super.fieldController,
      super.onChanged,
      required super.jsonKey,
      super.boringResponsiveSize,
      super.updateValueOnDismiss,
      super.decoration})
      : super(
            showPicker: (context) async => await showDateRangePicker(
                  context: context,
                  lastDate: DateTime.now(),
                  firstDate: DateTime(2022),
                ),
            valueToString: (value) => value == null
                ? ""
                : "${dateTimeToString(value.start)} - ${dateTimeToString(value.end)}");
}
