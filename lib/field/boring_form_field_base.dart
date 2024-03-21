// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields, must_be_immutable

import 'package:boring_form/boring_form.dart';
import 'package:flutter/material.dart';

abstract class BoringFormFieldBase<T, TT> extends StatelessWidget {
  final FieldPath fieldPath;
  final List<FieldPath> observedFields;
  final ValidationFunction<T> validationFunction;
  final DecorationBuilder<T>? _decorationBuilder;
  final bool? _readOnly;
  final Function(BoringFormController formController, T? fieldValue)? onChanged;

  const BoringFormFieldBase({
    super.key,
    required this.fieldPath,
    this.observedFields = const [],
    this.onChanged,
    // required this.builder,
    this.validationFunction,
    DecorationBuilder<T>? decoration,
    bool? readOnly,
  })  : _readOnly = readOnly,
        _decorationBuilder = decoration;

  bool isReadOnly(BoringFormTheme formTheme) =>
      _readOnly ?? formTheme.style.readOnly;

  void setChangedValue(BoringFormController formController, T? newValue) {
    formController.setFieldValue<T?>(fieldPath, newValue);
    onChanged?.call(formController, newValue);
  }

  TT onObservedFieldsChange(BoringFormController formController);

  void onSelfChange(BoringFormController formController, T? fieldValue);

  @override
  Widget build(BuildContext context);

  BoringFieldDecoration<T>? getFieldDecoration(
          BoringFormController formController) =>
      _decorationBuilder?.call(formController);

  InputDecoration getInputDecoration(BoringFormController formController,
      BoringFormTheme formTheme, String? errorMessage, T? value) {
    final formStyle = formTheme.style;

    final decoration = getFieldDecoration(formController);

    return formStyle.inputDecoration.copyWith(
        labelText: (formStyle.labelOverField || decoration?.label == null)
            ? null
            : decoration?.label,
        icon: decoration?.icon,
        errorText: errorMessage,
        helperText: decoration?.helperText,
        hintText: decoration?.hintText,
        prefix: decoration?.prefix,
        prefixIcon: decoration?.prefixIcon,
        prefixText: decoration?.prefixText,
        suffix: decoration?.suffix,
        suffixIcon: decoration?.suffixIcon,
        suffixText: decoration?.suffixText,
        counter: decoration?.counter?.call(value));
  }
}
