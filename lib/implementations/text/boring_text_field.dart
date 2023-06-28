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
      bool? readOnly,
      super.decoration})
      : super(readOnly: readOnly);

  final textEditingController = TextEditingController();

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
      child: ValueListenableBuilder(
        valueListenable: controller.autoValidate
            ? ValueNotifier(false)
            : controller.hideError,
        builder: (BuildContext context, bool value, Widget? child) {
          return TextField(
            readOnly: isReadOnly(context),
            enabled: !isReadOnly(context),
            controller: textEditingController,
            minLines: minLines,
            maxLines: maxLines,
            textAlign: style.textAlign,
            style: style.textStyle,
            decoration: getDecoration(context, haveError: value),
            onChanged: ((value) {
              controller.value = value;
              controller.isValid;
            }),
          );
        },
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
      fieldController: fieldController ?? this.fieldController,
      onChanged: onChanged ?? this.onChanged,
      decoration: decoration ?? this.decoration,
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      jsonKey: jsonKey ?? this.jsonKey,
      displayCondition: displayCondition ?? this.displayCondition,
      minLines: minLines ?? this.minLines,
      maxLines: maxLines ?? this.maxLines,
      readOnly: readOnly,
    );
  }
}
