import 'dart:async';

import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

typedef DecorationBuilder<T> = BoringFieldDecoration<T>? Function(
    BFormController formController);

String? requiredValidationFunction<T>(
  T? value, {
  String errorMessage = "Campo richiesto",
}) {
  if (value == null) return errorMessage;
  if (value is String && value.isEmpty) return errorMessage;
  if (value is List && value.isEmpty) return errorMessage;
  if (value is bool && !value) return errorMessage;
  return null;
}

abstract class BFormField<T> extends BFormFieldAsync<T, void> {
  BFormField({
    super.key,
    required super.fieldPath,
    super.observedFields,
    super.decoration,
    super.validationFunction,
    super.required = true,
    super.readOnly,
    super.onChanged,
    super.responsiveSize,
  });

  @override
  Future<void> Function(Map<FieldPath, dynamic> observedValues)?
      get asyncComputations => null;

  @override
  Widget onError(BuildContext context) => throw UnimplementedError();

  @override
  Widget onLoading(BuildContext context) => Container();
}

abstract class BFormFieldAsync<T, TT> extends BFormObserver {
  final FieldPath fieldPath;
  final ValidationFunction<T> validationFunction;
  final bool required;
  final bool readOnly;
  final Function(BFormController formController, T? fieldValue)? onChanged;

  //CAN BE REMOVED??
  final DecorationBuilder<T>? _decorationBuilder;

  BFormFieldAsync({
    super.key,
    required this.fieldPath,
    super.observedFields,
    DecorationBuilder<T>? decoration,
    ValidationFunction<T>? validationFunction,
    this.required = true,
    this.readOnly = false,
    this.onChanged,
    super.responsiveSize,
  })  : _decorationBuilder = decoration,
        validationFunction = ((controller, value) {
          if (required) {
            return requiredValidationFunction(value) ??
                validationFunction?.call(controller, value);
          }
          return validationFunction?.call(controller, value);
        });

  //[START] DECORATIONS
  Widget _label(
    BoringFieldDecoration fieldDecoration,
    BFormController formController,
    BoringFormStyle style,
    FieldValidation fieldValidation,
  ) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              fieldDecoration.label!,
              style: style.inputDecoration.labelStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (fieldValidation.showRequiredLabel)
            const Text(' *', style: TextStyle(color: Colors.red))
        ],
      );

  BoringFieldDecoration<T>? getFieldDecoration(
          BFormController formController) =>
      _decorationBuilder?.call(formController);

  InputDecoration getInputDecoration(
    BFormController formController,
    BoringFormStyle style,
    T? value,
    FieldValidation fieldValidation,
  ) {
    final formStyle = style;

    final decoration = getFieldDecoration(formController);

    return formStyle.inputDecoration.copyWith(
        label: (formStyle.labelOverField ||
                decoration == null ||
                decoration.label == null)
            ? null
            : _label(decoration, formController, formStyle, fieldValidation),
        icon: decoration?.icon,
        errorText: fieldValidation.showError ? fieldValidation.error : null,
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
  //[END] DECORATIONS

  abstract final Future<TT?> Function(Map<FieldPath, dynamic> observedValues)?
      asyncComputations;

  Future<TT?> _performAsyncComputations(Map<FieldPath, dynamic> observedValues,
      BFormController formController) async {
    // ignore: invalid_use_of_protected_member
    formController.setLoadingField(fieldPath);
    try {
      final result = await asyncComputations?.call(observedValues);
      // ignore: invalid_use_of_protected_member
      formController.setDoneField(fieldPath);
      return result;
    } catch (e) {
      // ignore: invalid_use_of_protected_member
      formController.setErrorField(fieldPath);
      rethrow;
    }
  }

  void setChangedValue(BFormController formController, T? newValue) {
    formController.setFieldValue<T?>(fieldPath, newValue);
    onChanged?.call(formController, newValue);
  }

  void onSelfChange(BFormController formController, T? fieldValue) {}

  Widget _child(
    TT? computedData,
    BFormController formController,
    BoringFormStyle style,
  ) =>
      BoringRxWatcher(
        listenable: formController,
        selector: (controller) => controller.selectField<T?>(fieldPath,
            fieldMarkedReadonly: readOnly || style.readOnly,
            fieldRequired: required),
        builder: (context, child, value) {
          onSelfChange(formController, value.value);
          if (value.isHidden) {
            return Container();
          }
          return fieldBuilder(context, style, formController, value.value,
              value.validation, computedData);
        },
      );

  @override
  bool get hasPadding => true;

  @override
  Widget builder(BuildContext context, BFormController formController,
      Map<FieldPath, dynamic> observedValues) {
    formController.setValidationFunction(fieldPath, validationFunction);

    final style = BoringFormTheme.of(context).style;

    if (asyncComputations == null) {
      return _child(null, formController, style);
    }

    return BFutureBuilder<TT?>(
      future: () async =>
          _performAsyncComputations(observedValues, formController),
      onError: (error, stackTrace) => onError(context),
      loader: onLoading(context),
      onEmptyDataFunction: () => _child(null, formController, style),
      builder: (context, snapshot) {
        final computedData = snapshot.data;
        return _child(computedData, formController, style);
      },
    );
  }

  @override
  Widget onObservedError(BuildContext context) => onError(context);
  @override
  Widget onObservedLoading(BuildContext context) => onLoading(context);

  Widget onError(BuildContext context);
  Widget onLoading(BuildContext context);

  Widget fieldBuilder(
    BuildContext context,
    BoringFormStyle formStyle,
    BFormController formController,
    T? fieldValue,
    FieldValidation fieldValidation,
    TT? computedValue,
  );
}

abstract class BFormObserver extends StatelessWidget {
  final List<List<String>>? observedFields;
  final bool Function()? isShown;

  final BResponsiveSize? responsiveSize;

  const BFormObserver({
    super.key,
    this.observedFields = const [],
    this.isShown,
    this.responsiveSize,
  });

  bool get hasPadding => false;

  @override
  Widget build(BuildContext context) {
    final formController = BFormControllerProvider.controllerOf(context);
    final style = BoringFormTheme.of(context).style;
    return BResponsiveChild.size(
      responsiveSize: responsiveSize ?? style.responsiveSize,
      child: Padding(
        padding: hasPadding ? style.fieldsPadding : EdgeInsets.zero,
        child: BoringRxWatcher(
          listenable: formController,
          selector: (controller) => controller.observed(observedFields),
          builder: (context, child, value) {
            if (!(isShown?.call() ?? true)) return Container();
            return switch (value) {
              AsyncValueLoading() => onObservedLoading(context),
              AsyncValueError() => onObservedError(context),
              AsyncValueDone() => builder(context, formController, value.data),
            };
          },
        ),
      ),
    );
  }

  Widget onObservedLoading(BuildContext context);
  Widget onObservedError(BuildContext context);

  Widget builder(
    BuildContext context,
    BFormController formController,
    Map<FieldPath, dynamic> observedValues,
  );
}

typedef BFormObserverBuilder = Widget Function(BuildContext context,
    BFormController formController, Map<FieldPath, dynamic> observedValues);

class BFormObserverWidget extends BFormObserver {
  final BFormObserverBuilder _builder;

  final Function(BuildContext context)? _onObservedError;
  final Function(BuildContext context)? _onObservedLoading;

  const BFormObserverWidget({
    super.key,
    required super.observedFields,
    required BFormObserverBuilder builder,
    Function(BuildContext context)? onObservedError,
    Function(BuildContext context)? onObservedLoading,
  })  : _builder = builder,
        _onObservedError = onObservedError,
        _onObservedLoading = onObservedLoading;

  @override
  Widget builder(BuildContext context, BFormController formController,
          Map<FieldPath, dynamic> observedValues) =>
      _builder(context, formController, observedValues);

  @override
  Widget onObservedError(BuildContext context) =>
      _onObservedError?.call(context) ?? const Text("ERRORE");

  @override
  Widget onObservedLoading(BuildContext context) =>
      _onObservedLoading?.call(context) ??
      const BSkeleton.custom(child: TextField(readOnly: true));
}
