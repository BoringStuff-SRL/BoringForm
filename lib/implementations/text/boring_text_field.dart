// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/boring_form.dart';
import 'package:flutter/material.dart';

class BoringTextField extends BoringField<String> {
  BoringTextField(
      {super.key,
      super.fieldController,
      super.onChanged,
      this.minLines = 1,
      this.maxLines = 1,
      required super.jsonKey,
      super.displayCondition,
      super.boringResponsiveSize,
      super.decoration});

  late final textEditingController = TextEditingController();

  final int minLines;
  final int maxLines;

  @override
  bool setInitialValue(String? initialValue) {
    final v = super.setInitialValue(initialValue);
    if (v) {
      textEditingController.text = fieldController.value ?? "";
    }
    return v;
  }

  @override
  Widget builder(context, controller, child) {
    final style = getStyle(context);
    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: TextField(
        readOnly: isReadOnly(context),
        enabled: !isReadOnly(context),
        controller: textEditingController,
        minLines: minLines,
        maxLines: maxLines,
        decoration: getDecoration(context),
        onChanged: ((value) {
          controller.value = value;
        }),
      ),
    );
  }

  @override
  void onValueChanged(String? newValue) {}

  @override
  BoringTextField copyWith(
      {BoringFieldController<String>? fieldController,
      void Function(String? p1)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic> p1)? displayCondition,
      int? minLines,
      int? maxLines}) {
    return BoringTextField(
      minLines: minLines ?? this.minLines,
      maxLines: maxLines ?? this.maxLines,
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      jsonKey: jsonKey ?? this.jsonKey,
      decoration: decoration ?? this.decoration,
      onChanged: onChanged ?? this.onChanged,
      displayCondition: displayCondition ?? this.displayCondition,
      fieldController: fieldController ?? this.fieldController,
    );
  }
}
