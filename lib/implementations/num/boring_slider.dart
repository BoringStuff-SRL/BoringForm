// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/boring_form.dart';
import 'package:boring_form/field/boring_form_field.dart';
import 'package:flutter/material.dart';

class BoringSlider extends BoringFormField<double> {
  const BoringSlider({
    super.key,
    required super.fieldPath,
    // super.fieldController,
    super.decoration,
    // super.boringResponsiveSize,
    this.min = 0,
    this.max = 1,
    // super.displayCondition,
    this.showValueLabel = true,
    this.divisions,
    // super.onChanged
  });

  final double min, max;
  // late final initialValue = fieldController.initialValue ?? 0;
  final int? divisions;
  final bool showValueLabel;

  @override
  onObservedFieldsChange(BoringFormController formController) {}

  @override
  Widget builder(BuildContext context, BoringFormTheme formTheme,
      BoringFormController formController, double? fieldValue, String? errror) {
    final inputDecoration =
        getInputDecoration(formController, formTheme, errror, fieldValue);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (inputDecoration.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 4),
            child: Text(
              inputDecoration.labelText ?? "",
              style: inputDecoration.labelStyle,
            ),
          ),
        Slider(
          min: min,
          max: max,
          // activeColor:
          //     value ? null : Theme.of(context).colorScheme.error,
          // inactiveColor: value
          //     ? null
          //     : Theme.of(context).colorScheme.error.withAlpha(40),
          divisions: divisions,
          value: fieldValue ?? 0,
          label: showValueLabel ? fieldValue?.toStringAsFixed(2) : null,
          // InputDecoration(
          // ),
          onChanged: (value) => formController.setFieldValue(fieldPath, value),
        )
      ],
    );
  }

  @override
  void onSelfChange(BoringFormController formController, double? fieldValue) {}

  // @override
  // void onValueChanged(double? newValue) {}

  // @override
  // BoringField copyWith({
  //   BoringFieldController<double>? fieldController,
  //   void Function(double? p1)? onChanged,
  //   BoringFieldDecoration? decoration,
  //   BoringResponsiveSize? boringResponsiveSize,
  //   String? jsonKey,
  //   bool Function(Map<String, dynamic> p1)? displayCondition,
  //   double? min,
  //   double? max,
  //   bool? showValueLabel,
  //   int? divisions,
  // }) {
  //   return BoringSlider(
  //     boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
  //     jsonKey: jsonKey ?? this.jsonKey,
  //     decoration: decoration ?? this.decoration,
  //     onChanged: onChanged ?? this.onChanged,
  //     displayCondition: displayCondition ?? this.displayCondition,
  //     fieldController: fieldController ?? this.fieldController,
  //     max: max ?? this.min,
  //     min: min ?? this.min,
  //     showValueLabel: showValueLabel ?? this.showValueLabel,
  //     divisions: divisions ?? this.divisions,
  //   );
  // }
}

class BoringRangeSlider extends BoringFormField<RangeValues> {
  const BoringRangeSlider({
    super.key,
    required super.fieldPath,
    // required super.fieldController,
    super.decoration,
    // super.boringResponsiveSize,
    this.min = 0,
    this.max = 1,
    this.showValueLabel = true,
    this.divisions,
    // super.onChanged
  });

  final double min, max;
  final bool showValueLabel;
  // late final initialValue = fieldController.initialValue ?? 0;
  final int? divisions;

  @override
  Widget builder(BuildContext context, BoringFormTheme formTheme,
      BoringFormController formController, fieldValue, String? errror) {
    final inputDecoration =
        getInputDecoration(formController, formTheme, errror, fieldValue);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (inputDecoration.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 4),
            child: Text(
              inputDecoration.labelText ?? "",
              style: inputDecoration.labelStyle,
            ),
          ),
        RangeSlider(
          min: min,
          max: max,
          divisions: divisions,
          values: fieldValue ?? RangeValues(min, max),
          // InputDecoration(
          // ),
          labels: showValueLabel
              ? RangeLabels(fieldValue?.start.toStringAsFixed(2) ?? "",
                  fieldValue?.end.toStringAsFixed(2) ?? "")
              : null,
          onChanged: (value) => formController.setFieldValue(fieldPath, value),
        )
      ],
    );
  }

  @override
  void onSelfChange(
      BoringFormController formController, RangeValues? fieldValue) {
    // TODO: implement onSelfChange
  }

  // @override
  // void onValueChanged(RangeValues? newValue) {}

  // @override
  // BoringRangeSlider copyWith({
  //   BoringFieldController<RangeValues>? fieldController,
  //   void Function(RangeValues? p1)? onChanged,
  //   BoringFieldDecoration? decoration,
  //   BoringResponsiveSize? boringResponsiveSize,
  //   String? jsonKey,
  //   bool Function(Map<String, dynamic> p1)? displayCondition,
  //   double? min,
  //   double? max,
  //   bool? showValueLabel,
  //   int? divisions,
  // }) {
  //   return BoringRangeSlider(
  //     boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
  //     jsonKey: jsonKey ?? this.jsonKey,
  //     decoration: decoration ?? this.decoration,
  //     onChanged: onChanged ?? this.onChanged,
  //     fieldController: fieldController ?? this.fieldController,
  //     max: max ?? this.min,
  //     min: min ?? this.min,
  //     showValueLabel: showValueLabel ?? this.showValueLabel,
  //     divisions: divisions ?? this.divisions,
  //   );
  // }
}
