// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields, must_be_immutable

import 'package:boring_form/boring_form.dart';
import 'package:boring_form/field/boring_form_field_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BoringFormField<T> extends BoringFormFieldBase<T, void> {
  const BoringFormField({
    super.key,
    this.onChanged,
    required super.fieldPath,
    super.observedFields = const [],
    super.validationFunction,
    super.decoration,
    super.readOnly,
  });

  final Function(BoringFormController formController, T? fieldValue)? onChanged;

  Widget builder(BuildContext context, BoringFormTheme formTheme,
      BoringFormController formController, T? fieldValue, String? error);

  @override
  void onObservedFieldsChange(BoringFormController formController) {}

  @override
  Widget build(BuildContext context) {
    final formController =
        Provider.of<BoringFormController>(context, listen: false);
    final formTheme = BoringFormTheme.of(context);
    formController.setValidationFunction(fieldPath, validationFunction);
    return Selector<BoringFormController, List<dynamic>>(
        selector: (_, formController) =>
            formController.selectPaths(observedFields, includeError: true),
        builder: (context, _, __) {
          return Selector<
                  BoringFormController, // T?>(
                  ({T? fieldValue, String? error})>(
              selector: (_, formController) => (
                    fieldValue: formController.getValue(fieldPath) as T?,
                    error: formController.getFieldError(fieldPath)
                  ),
              builder: (context, value, child) {
                onSelfChange(formController, value.fieldValue);
                return Padding(
                  padding: formTheme.style.fieldsPadding,
                  child: builder(context, formTheme, formController,
                      value.fieldValue, value.error),
                );
              });
        });
  }
}
