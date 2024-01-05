import 'dart:async';

import 'package:boring_form/field/boring_form_field_with_async_calculations.dart';
import 'package:boring_form/form/boring_form_controller.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boringcore/boring_dropdown.dart';
import 'package:flutter/material.dart';

class BoringDropdownMultiChoiceField<T>
    extends BoringFormFieldWithAsyncCalculations<List<T>,
        List<BoringChoiceItem<T>>> {
  const BoringDropdownMultiChoiceField({
    super.key,
    required super.fieldPath,
    required this.getItems,
    super.decoration,
    super.observedFields,
    super.readOnly,
    super.validationFunction,
    required this.toBoringChoiceItem,
    this.onChanged,
    this.onAdd,
    this.loadingIndicator = const CircularProgressIndicator(),
    this.clearable = true,
    this.searchable = true,
    this.callFutureOnStopWriting = true,
    this.boringDropdownStyle = const BoringDropdownStyle(),
    this.boringDropdownLoadingMode = BoringDropdownLoadingMode.onOpen,
    this.debouncingTime = const Duration(milliseconds: 300),
    this.initialItems,
  });

  final Future<List<BoringChoiceItem<T>>> Function(String search) getItems;
  final BoringChoiceItem<T> Function(T) toBoringChoiceItem;
  final void Function(BoringFormController formController, List<T>? fieldValue)?
      onChanged;

  final FutureOr<List<BoringChoiceItem<T>>?> Function(String)? onAdd;
  final bool callFutureOnStopWriting;
  final bool searchable;
  final BoringDropdownStyle boringDropdownStyle;
  final BoringDropdownLoadingMode boringDropdownLoadingMode;
  final bool clearable;
  final Duration debouncingTime;
  final AsyncSnapshot<List<BoringChoiceItem<T>>>? initialItems;
  final Widget loadingIndicator;
  @override
  Widget builder(
      BuildContext context,
      BoringFormTheme formTheme,
      BoringFormController formController,
      List<T>? fieldValue,
      String? error,
      AsyncSnapshot<List<BoringChoiceItem<T>>> calculations) {
    return BoringDropdownMultichoice(
      value: fieldValue?.map((e) => toBoringChoiceItem(e)).toList(),
      searchItems: getItems,
      onChanged: (values) =>
          setChangedValue(formController, values?.map((e) => e.value).toList()),
      readOnly: isReadOnly(formTheme),
      onAdd: onAdd,
      callFutureOnStopWriting: callFutureOnStopWriting,
      boringDropdownLoadingMode: boringDropdownLoadingMode,
      searchable: searchable,
      boringDropdownStyle: boringDropdownStyle.copyWith(
          inputDecoration:
              getInputDecoration(formController, formTheme, error, fieldValue),
          onClearIcon: formTheme.style.eraseValueWidget,
          choiceItemDisplayTextStyle: formTheme.style.textStyle),
      clearable: clearable,
      errorMessage: error,
      debouncingTime: debouncingTime,
      initialItems: initialItems,
      loadingIndicator: loadingIndicator,
    );
  }

  @override
  Future<List<BoringChoiceItem<T>>> onObservedFieldsChange(
          BoringFormController formController) =>
      getItems("");

  @override
  void onSelfChange(BoringFormController formController, List<T>? fieldValue) {
    if (onChanged != null) {
      onChanged?.call(formController, fieldValue);
    }
  }
}
