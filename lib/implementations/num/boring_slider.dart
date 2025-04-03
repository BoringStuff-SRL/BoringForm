// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringSlider extends BFormField<double> {
  BoringSlider({
    super.key,
    required super.fieldPath,
    super.observedFields,
    super.decoration,
    super.validationFunction,
    super.required,
    super.responsiveSize,
    super.readOnly,
    super.onChanged,
    this.min = 0,
    this.max = 1,
    this.showValueLabel = true,
    this.divisions,
  });

  final double min, max;
  final int? divisions;
  final bool showValueLabel;

  @override
  Widget fieldBuilder(
    BuildContext context,
    BoringFormStyle formStyle,
    BFormController formController,
    double? fieldValue,
    FieldValidation fieldValidation,
    void computedValue,
    // bool readOnly,
  ) {
    final inputDecoration = getInputDecoration(
        formController, formStyle, fieldValue, fieldValidation);
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
          divisions: divisions,
          value: fieldValue ?? 0,
          label: showValueLabel ? fieldValue?.toStringAsFixed(2) : null,
          onChanged: readOnly
              ? null
              : (value) => setChangedValue(formController, value),
        ),
      ],
    );
  }
}

class BoringRangeSlider extends BFormField<RangeValues> {
  BoringRangeSlider({
    super.key,
    required super.fieldPath,
    super.observedFields,
    super.decoration,
    super.validationFunction,
    super.required = true,
    super.readOnly,
    super.onChanged,
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
  Widget fieldBuilder(
    BuildContext context,
    BoringFormStyle formStyle,
    BFormController formController,
    RangeValues? fieldValue,
    FieldValidation fieldValidation,
    void computedValue,
    // bool readOnly,
  ) {
    final inputDecoration = getInputDecoration(
        formController, formStyle, fieldValue, fieldValidation);
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
          onChanged: (value) => setChangedValue(formController, value),
        )
      ],
    );
  }
}
