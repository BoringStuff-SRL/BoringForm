// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/field/bform_field.dart';
import 'package:boring_form/form/bform_controller.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringCheckBoxField extends BFormField<bool> {
  BoringCheckBoxField({
    super.key,
    required super.fieldPath,
    super.observedFields,
    super.validationFunction,
    super.decoration,
    super.readOnly,
    this.checkColor,
    this.mainAxisAlignment,
    this.unCheckColor,
    super.onChanged,
  });

  final Color? unCheckColor;
  final Color? checkColor;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget fieldBuilder(
      BuildContext context,
      BoringFormStyle formStyle,
      BFormController formController,
      bool? fieldValue,
      FieldValidation fieldValidation,
      void computedValue,
      bool readOnly) {
    final fieldDecoration = getFieldDecoration(formController);
    final inputDecoration = getInputDecoration(
        formController, formStyle, fieldValue, fieldValidation);

    return Column(
      children: [
        GestureDetector(
          onTap: readOnly
              ? null
              : () => setChangedValue(formController,
                  !(formController.getValue(fieldPath) ?? false)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            children: [
              Container(
                child: (formController.getValue(fieldPath) as bool?) ?? false
                    ? Icon(Icons.check_box_rounded,
                        color: checkColor ?? inputDecoration.iconColor)
                    : Icon(Icons.check_box_outline_blank_rounded,
                        color: unCheckColor ?? inputDecoration.prefixIconColor),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Column(
                  children: [
                    Text(
                      fieldDecoration?.label ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              ((formController.getValue(fieldPath) as bool?) ??
                                      false)
                                  ? checkColor ?? inputDecoration.iconColor
                                  : unCheckColor ??
                                      inputDecoration.prefixIconColor),
                    ),
                    if (fieldValidation.error != null) ...[
                      Text(fieldValidation.error!,
                          style: inputDecoration.errorStyle ??
                              const TextStyle(color: Colors.red)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        fieldDecoration?.helperText != null
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(fieldDecoration?.helperText ?? ""),
              )
            : Container(),
      ],
    );
  }
}
