// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/field/boring_field_controller.dart';
import 'package:boring_form/theme/boring_field_decoration.dart';
import 'package:boring_form/theme/boring_responsive_size.dart';
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
            min: min,
            max: max,
            divisions: divisions,
            value: fieldController.value ?? 0,
            label: showValueLabel
                ? fieldController.value?.toStringAsFixed(2)
                : null,
            // InputDecoration(
            // ),
            onChanged: (value) => fieldController.value = value,
          ),
        ],
      ),
    );
  }

  @override
  void onValueChanged(double? newValue) {}

  @override
  BoringField copyWith({
    BoringFieldController<double>? fieldController,
    void Function(double? p1)? onChanged,
    BoringFieldDecoration? decoration,
    BoringResponsiveSize? boringResponsiveSize,
    String? jsonKey,
    bool Function(Map<String, dynamic> p1)? displayCondition,
    double? min,
    double? max,
    bool? showValueLabel,
    int? divisions,
  }) {
    return BoringSlider(
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      jsonKey: jsonKey ?? this.jsonKey,
      decoration: decoration ?? this.decoration,
      onChanged: onChanged ?? this.onChanged,
      displayCondition: displayCondition ?? this.displayCondition,
      fieldController: fieldController ?? this.fieldController,
      max: max ?? this.min,
      min: min ?? this.min,
      showValueLabel: showValueLabel ?? this.showValueLabel,
      divisions: divisions ?? this.divisions,
    );
  }
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
            min: min,
            max: max,
            divisions: divisions,
            values: fieldController.value ?? RangeValues(min, max),
            // InputDecoration(
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

  @override
  BoringRangeSlider copyWith({
    BoringFieldController<RangeValues>? fieldController,
    void Function(RangeValues? p1)? onChanged,
    BoringFieldDecoration? decoration,
    BoringResponsiveSize? boringResponsiveSize,
    String? jsonKey,
    bool Function(Map<String, dynamic> p1)? displayCondition,
    double? min,
    double? max,
    bool? showValueLabel,
    int? divisions,
  }) {
    return BoringRangeSlider(
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      jsonKey: jsonKey ?? this.jsonKey,
      decoration: decoration ?? this.decoration,
      onChanged: onChanged ?? this.onChanged,
      fieldController: fieldController ?? this.fieldController,
      max: max ?? this.min,
      min: min ?? this.min,
      showValueLabel: showValueLabel ?? this.showValueLabel,
      divisions: divisions ?? this.divisions,
    );
  }
}
