import 'package:boring_form/form/boring_form_controller.dart';
import 'package:boring_form/implementations/pickers/boring_picker_field.dart';
import 'package:boring_form/utils/datetime_extnesions.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class BoringDateTimeField extends BoringPickerField<DateTime> {
  static const outOfBoundError =
      "initial date must be between firstDate and lastDate"; //TODO make this a parameter [or better: add translations]
  BoringDateTimeField({
    super.key,
    required super.fieldPath,
    super.observedFields,
    ValidationFunction<DateTime>? validationFunction,
    super.decoration,
    super.readOnly,
    super.updateValueOnDismiss,
    super.showEraseValueButton,
    required DateTime firstDate,
    required DateTime lastDate,
    super.onChanged,
  }) : super(
            validationFunction:
                (BoringFormController formController, DateTime? value) {
              final error = validationFunction?.call(formController, value);
              final boundsError =
                  value == null || (value <= lastDate && value >= firstDate)
                      ? null
                      : outOfBoundError;
              return error ?? boundsError;
            },
            showPicker: (context, formController, fieldValue) async =>
                await showOmniDateTimePicker(
                    context: context,
                    initialDate: fieldValue,
                    is24HourMode: true,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    isForce2Digits: true),
            valueToString: (value) => value == null
                ? ''
                : "${dateTimeToString(value)}, ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}");
}

String dateTimeToString(
        DateTime? dt) => //TODO add internazionalization for this function too
    dt != null ? "${dt.day}/${dt.month}/${dt.year}" : "";

String dateTimeRangeToString(
        DateTimeRange?
            dt) => //TODO add internazionalization for this function too
    dt != null
        ? "${dateTimeToString(dt.start)} - ${dateTimeToString(dt.end)}"
        : "";

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

class BoringDateRangeField extends BoringPickerField<DateTimeRange> {
  static const outOfBoundError = BoringDateTimeField
      .outOfBoundError; //TODO make this a parameter [or better: add translations]
  BoringDateRangeField({
    super.key,
    required super.fieldPath,
    super.observedFields,
    ValidationFunction<DateTimeRange>? validationFunction,
    super.decoration,
    super.readOnly,
    super.updateValueOnDismiss,
    super.showEraseValueButton,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    required DateTime firstDate,
    required DateTime lastDate,
    super.onChanged,
  })  : assert(firstDate <= lastDate, "firstDate must be less than lastDate"),
        super(
          validationFunction:
              (BoringFormController formController, DateTimeRange? value) {
            final error = validationFunction?.call(formController, value);

            final isOutOfBound = value == null
                ? false
                : (value.start <= firstDate || value.end >= lastDate);

            final boundsError =
                value == null || !isOutOfBound ? null : outOfBoundError;
            return error ?? boundsError;
          },
          showPicker: (context, formController, fieldValue) async =>
              await showDateRangePicker(
            context: context,
            initialEntryMode: initialEntryMode,
            initialDateRange: fieldValue,
            firstDate: firstDate,
            lastDate: lastDate,
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: AlertDialog(
                  backgroundColor: Colors.transparent,
                  contentPadding: EdgeInsets.zero,
                  content: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                      maxHeight: 500,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: child!,
                    ),
                  ),
                ),
              );
            },
          ),
          valueToString: dateTimeRangeToString,
        );
}

class BoringDateField extends BoringPickerField<DateTime> {
  static const outOfBoundError = BoringDateTimeField
      .outOfBoundError; //TODO make this a parameter [or better: add translations]
  BoringDateField({
    super.key,
    required super.fieldPath,
    super.observedFields,
    ValidationFunction<DateTime>? validationFunction,
    super.decoration,
    super.readOnly,
    super.updateValueOnDismiss,
    super.showEraseValueButton,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    required DateTime firstDate,
    required DateTime lastDate,
    super.onChanged,
  })  : assert(firstDate <= lastDate, "firstDate must be less than lastDate"),
        super(
            validationFunction:
                (BoringFormController formController, DateTime? value) {
              final error = validationFunction?.call(formController, value);
              final boundsError =
                  value == null || (value <= lastDate && value >= firstDate)
                      ? null
                      : outOfBoundError;
              return error ?? boundsError;
            },
            showPicker: (context, formController, fieldValue) async =>
                await showDatePicker(
                    context: context,
                    initialEntryMode: initialEntryMode,
                    initialDate: fieldValue ??
                        middle(firstDate, DateTime.now(), lastDate),
                    firstDate: firstDate,
                    lastDate: lastDate,
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    }),
            valueToString: dateTimeToString);
  // final DateTime firstDate, lastDate;
  // final DatePickerEntryMode initialEntryMode;

  // void initialDateAssertion(DateTime? initialDate) {
  //   assert(
  //       initialDate == null ||
  //           (initialDate < lastDate && initialDate > firstDate),
  //       "initial date must be between firstDate and lastDate");
  // }
}

class BoringTimeField extends BoringPickerField<TimeOfDay> {
  BoringTimeField({
    super.key,
    required super.fieldPath,
    super.observedFields,
    ValidationFunction<TimeOfDay>? validationFunction,
    super.decoration,
    super.readOnly,
    super.updateValueOnDismiss,
    super.showEraseValueButton,
    TimePickerEntryMode initialEntryMode = TimePickerEntryMode.inputOnly,
    super.onChanged,
    // required DateTime firstDate,
    // required DateTime lastDate,
  }) : super(
            validationFunction:
                (BoringFormController formController, TimeOfDay? value) {
              final error = validationFunction?.call(formController, value);

              return error;
            },
            showPicker: (context, formController, fieldValue) async =>
                await showTimePicker(
                    context: context,
                    initialEntryMode: initialEntryMode,
                    initialTime: fieldValue ?? TimeOfDay.now(),
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
}

class BoringYearPicker extends BoringPickerField<DateTime> {
  BoringYearPicker({
    super.key,
    super.decoration,
    super.readOnly,
    required super.fieldPath,
    ValidationFunction<DateTime>? validationFunction,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? selected,
  }) : super(
          validationFunction:
              (BoringFormController formController, DateTime? value) {
            final error = validationFunction?.call(formController, value);
            return error;
          },
          showPicker: (context, formController, fieldValue) async =>
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(decoration?.call(formController)?.label ??
                          "Select a year"),
                      content: SizedBox(
                        width: 300,
                        height: 300,
                        child: YearPicker(
                          firstDate: firstDate,
                          lastDate: lastDate,
                          selectedDate:
                              fieldValue ?? selected ?? DateTime.now(),
                          onChanged: (DateTime dateTime) {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  }),
          valueToString: (value) => value == null ? "" : "${value.year}",
        );
}
