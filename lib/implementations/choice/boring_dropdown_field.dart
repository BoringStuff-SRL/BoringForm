import 'dart:async';

import 'package:boring_form/field/boring_form_field_with_async_calculations.dart';
import 'package:boring_form/form/boring_form_controller.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boringcore/boring_dropdown.dart';
import 'package:flutter/material.dart';

class BoringDropdownField<T>
    extends BoringFormFieldWithAsyncCalculations<T, List<BoringChoiceItem<T>>> {
  const BoringDropdownField({
    super.key,
    required super.fieldPath,
    required this.getItems,
    super.decoration,
    super.observedFields,
    super.readOnly,
    super.validationFunction,
    this.onChanged,
    required this.toBoringChoiceItem,
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
  final BoringChoiceItem<T> Function(T element) toBoringChoiceItem;
  final void Function(BoringFormController formController, T? fieldValue)?
      onChanged;

  final FutureOr<BoringChoiceItem<T>?> Function(String)? onAdd;
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
      T? fieldValue,
      String? error,
      AsyncSnapshot<List<BoringChoiceItem<T>>> calculations) {
    return BoringDropdown(
      value: ValueNotifier(fieldValue != null ? toBoringChoiceItem(fieldValue) : null) ,
      searchItems: getItems,
      onChanged: (value) => setChangedValue(formController, value?.value),
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
  void onSelfChange(BoringFormController formController, T? fieldValue) {}
}
