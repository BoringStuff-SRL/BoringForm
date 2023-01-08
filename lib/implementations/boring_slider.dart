import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:flutter/material.dart';

class BoringSlider extends BoringField<double> {
  BoringSlider(
      {super.key,
      required super.jsonKey,
      super.fieldController,
      super.decoration,
      super.boringResponsiveSize,
      this.min = 0,
      this.max = 1,
      super.displayCondition,
      this.showValueLabel = true,
      this.divisions,
      super.onChanged});

  final double min, max;
  late final initialValue = fieldController.initialValue ?? 0;
  final int? divisions;
  final bool showValueLabel;

  @override
  Widget builder(context, controller, child) {
    return Padding(
      padding: getStyle(context).fieldsPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (getDecoration(context).labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 4),
              child: Text(
                getDecoration(context).labelText ?? "",
                style: getDecoration(context).labelStyle,
              ),
            ),
          Slider(
            min: min, max: max,
            divisions: divisions,
            value: fieldController.value ?? 0,
            label: showValueLabel
                ? fieldController.value?.toStringAsFixed(2)
                : null, // InputDecoration(
            // ),
            onChanged: (value) => fieldController.value = value,
          ),
        ],
      ),
    );
  }

  @override
  void onValueChanged(double? newValue) {}
}

class BoringRangeSlider extends BoringField<RangeValues> {
  BoringRangeSlider(
      {super.key,
      required super.jsonKey,
      required super.fieldController,
      super.decoration,
      super.boringResponsiveSize,
      this.min = 0,
      this.max = 1,
      this.showValueLabel = true,
      this.divisions,
      super.onChanged});

  final double min, max;
  final bool showValueLabel;
  late final initialValue = fieldController.initialValue ?? 0;
  final int? divisions;
  @override
  Widget builder(context, controller, child) {
    return Padding(
      padding: getStyle(context).fieldsPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (getDecoration(context).labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 4),
              child: Text(
                getDecoration(context).labelText ?? "",
                style: getDecoration(context).labelStyle,
              ),
            ),
          RangeSlider(
            min: min, max: max,
            divisions: divisions,
            values: fieldController.value ??
                RangeValues(min, max), // InputDecoration(
            // ),
            labels: showValueLabel
                ? RangeLabels(
                    fieldController.value?.start.toStringAsFixed(2) ?? "",
                    fieldController.value?.end.toStringAsFixed(2) ?? "")
                : null,
            onChanged: (value) => fieldController.value = value,
          )
        ],
      ),
    );
  }

  @override
  void onValueChanged(RangeValues? newValue) {}
}
