// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/field/bform_field.dart';
import 'package:boring_form/form/bform_controller.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringPickerField<T> extends BFormField<T> {
  final _textEditingController = TextEditingController();
  final bool updateValueOnDismiss;
  final String Function(T? value) valueToString;
  final bool showEraseValueButton;

  final Future<T?> Function(BuildContext context,
      BoringFormController formController, T? fieldValue) showPicker;

  BoringPickerField({
    super.key,
    required super.fieldPath,
    super.observedFields,
    super.decoration,
    super.readOnly,
    super.validationFunction,
    required this.valueToString,
    required this.showPicker,
    this.updateValueOnDismiss = false,
    this.showEraseValueButton = false,
    super.onChanged,
    super.required,
  });

  @override
  Widget fieldBuilder(
      BuildContext context,
      BoringFormStyle formStyle,
      BoringFormController formController,
      T? fieldValue,
      FieldValidation fieldValidation,
      void computedValue,
      bool readOnly) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            enabled: readOnly,
            readOnly: true,
            controller: _textEditingController,
            textAlign: formStyle.textAlign,
            style: formStyle.textStyle,
            decoration: getInputDecoration(
                formController, formStyle, fieldValue, fieldValidation),
            onTap: () async {
              if (readOnly) {
                return;
              }

              T? value = await showPicker(context, formController, fieldValue);
              if (value != null || updateValueOnDismiss) {
                setChangedValue(formController, value);
                _textEditingController.text = valueToString(value);
              }
            },
          ),
        ),
        if (showEraseValueButton && fieldValue != null) ...[
          const SizedBox(width: 5),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setChangedValue(formController, null);
                _textEditingController.text = "";
              },
              child: formStyle.eraseValueWidget,
            ),
          ),
        ]
      ],
    );
  }

  // void onValueChanged(T? newValue) {}

  // @override
  // BoringPickerField<T> copyWith(
  //     {BoringFieldController<T>? fieldController,
  //     void Function(T? value)? onChanged,
  //     BoringFieldDecoration? decoration,
  //     BoringResponsiveSize? boringResponsiveSize,
  //     String? jsonKey,
  //     bool Function(Map<String, dynamic> p1)? displayCondition,
  //     String Function(T?)? valueToString,
  //     Future<T> Function(BuildContext)? showPicker,
  //     bool? updateValueOnDismiss}) {
  //   return BoringPickerField(
  //     fieldController: fieldController ?? this.fieldController,
  //     onChanged: onChanged ?? this.onChanged,
  //     decoration: decoration ?? this.decoration,
  //     boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
  //     jsonKey: jsonKey ?? this.jsonKey,
  //     displayCondition: displayCondition ?? this.displayCondition,
  //     valueToString: valueToString ?? this.valueToString,
  //     showPicker: showPicker ?? this.showPicker,
  //     updateValueOnDismiss: updateValueOnDismiss ?? this.updateValueOnDismiss,
  //   );
  // }
}
