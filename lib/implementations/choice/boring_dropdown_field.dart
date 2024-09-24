import 'dart:async';

import 'package:boring_form/field/boring_form_field_with_async_calculations.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringDropdownField<T>
    extends BoringFormFieldWithAsyncCalculations<T, List<BChoiceItem<T>>> {
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
    this.boringDropdownStyle = const BDropdownTheme(),
    this.boringDropdownLoadingMode = BDropdownLoadingMode.onOpen,
    this.debouncingTime = const Duration(milliseconds: 300),
    this.initialItems,
  });

  final Future<List<BChoiceItem<T>>> Function(String search) getItems;
  final BChoiceItem<T> Function(T element) toBoringChoiceItem;
  final void Function(BoringFormController formController, T? fieldValue)?
      onChanged;

  final FutureOr<BChoiceItem<T>?> Function(String)? onAdd;
  final bool callFutureOnStopWriting;
  final bool searchable;
  final BDropdownTheme boringDropdownStyle;
  final BDropdownLoadingMode boringDropdownLoadingMode;
  final bool clearable;
  final Duration debouncingTime;
  final AsyncSnapshot<List<BChoiceItem<T>>>? initialItems;
  final Widget loadingIndicator;

  @override
  Widget builder(
      BuildContext context,
      BoringFormStyle formTheme,
      BoringFormController formController,
      T? fieldValue,
      String? error,
      AsyncSnapshot<List<BChoiceItem<T>>> calculations) {
    return BDropdown(
      value:ValueNotifier(fieldValue != null ? toBoringChoiceItem(fieldValue) : null),
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
          onClearIcon: formTheme.eraseValueWidget,
          choiceItemDisplayTextStyle: formTheme.textStyle),
      clearable: clearable,
      errorMessage: error,
      debouncingTime: debouncingTime,
      initialItems: initialItems,
      loadingIndicator: loadingIndicator,
    );
  }

  @override
  Future<List<BChoiceItem<T>>> onObservedFieldsChange(
          BoringFormController formController) =>
      getItems("");

  @override
  void onSelfChange(BoringFormController formController, T? fieldValue) {}
}
