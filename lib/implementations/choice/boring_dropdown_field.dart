import 'dart:async';

import 'package:boring_form/field/boring_form_field_with_async_calculations.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringDropdownField<T>
    extends BoringFormFieldWithAsyncCalculations<T, List<T>> {
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
    this.boringDropdownStyle,
    this.boringDropdownLoadingMode = BDropdownLoadingMode.onOpen,
    this.debouncingTime = const Duration(milliseconds: 300),
    this.initialItems,
    super.forceHideRequiredFieldLabel,
  });

  final Future<List<T>> Function(String search) getItems;
  final BChoiceItem<T> Function(T element) toBoringChoiceItem;
  final void Function(BoringFormController formController, T? fieldValue)?
      onChanged;

  final FutureOr<T?> Function(String)? onAdd;
  final bool callFutureOnStopWriting;
  final bool searchable;
  final BDropdownTheme? boringDropdownStyle;
  final BDropdownLoadingMode boringDropdownLoadingMode;
  final bool clearable;
  final Duration debouncingTime;
  final AsyncSnapshot<List<T>>? initialItems;
  final Widget loadingIndicator;

  @override
  Widget builder(
      BuildContext context,
      BoringFormStyle formTheme,
      BoringFormController formController,
      T? fieldValue,
      String? error,
      AsyncSnapshot<List<T>> calculations) {
    final dropdownStyle =
        boringDropdownStyle ?? BoringTheme.of(context).bDropdownTheme;

    return BDropdown<T>(
      value: ValueNotifier(fieldValue),
      searchItems: getItems,
      toDisplay: (v) => toBoringChoiceItem(v).display,
      onChanged: (value) => setChangedValue(formController, value),
      readOnly: isReadOnly(formTheme),
      onAdd: onAdd,
      callFutureOnStopWriting: callFutureOnStopWriting,
      boringDropdownLoadingMode: boringDropdownLoadingMode,
      searchable: searchable,
      boringDropdownStyle: dropdownStyle.copyWith(
        inputDecoration:
            getInputDecoration(formController, formTheme, error, fieldValue),
        onClearIcon: formTheme.eraseValueWidget,
        choiceItemDisplayTextStyle: formTheme.textStyle,
      ),
      clearable: clearable,
      errorMessage: error,
      debouncingTime: debouncingTime,
      initialItems: initialItems,
      loadingIndicator: loadingIndicator,
    );
  }

  @override
  Future<List<T>> onObservedFieldsChange(BoringFormController formController) =>
      getItems("");

  @override
  void onSelfChange(BoringFormController formController, T? fieldValue) {}
}

class BoringDropdownFieldID<T, ID>
    extends BoringFormFieldWithAsyncCalculations<ID, List<T>> {
  const BoringDropdownFieldID({
    super.key,
    required super.fieldPath,
    required this.getItems,
    required this.identifier,
    super.decoration,
    super.observedFields,
    super.readOnly,
    super.validationFunction,
    this.onChanged,
    required this.toDisplay,
    this.onAdd,
    this.loadingIndicator = const CircularProgressIndicator(),
    this.clearable = true,
    this.searchable = true,
    this.callFutureOnStopWriting = true,
    this.boringDropdownStyle,
    this.boringDropdownLoadingMode = BDropdownLoadingMode.onOpen,
    this.debouncingTime = const Duration(milliseconds: 300),
    this.initialItems,
    super.forceHideRequiredFieldLabel,
  });

  final Future<List<T>> Function(String search) getItems;
  final String Function(T element) toDisplay;
  final void Function(BoringFormController formController, ID? fieldValue)?
      onChanged;
  final ID Function(T element) identifier;

  final FutureOr<ID?> Function(String search)? onAdd;
  final bool callFutureOnStopWriting;
  final bool searchable;
  final BDropdownTheme? boringDropdownStyle;
  final BDropdownLoadingMode boringDropdownLoadingMode;
  final bool clearable;
  final Duration debouncingTime;
  final AsyncSnapshot<List<T>>? initialItems;
  final Widget loadingIndicator;

  @override
  Widget builder(
      BuildContext context,
      BoringFormStyle formTheme,
      BoringFormController formController,
      ID? fieldValue,
      String? error,
      AsyncSnapshot<List<T>> calculations) {
    final dropdownStyle =
        boringDropdownStyle ?? BoringTheme.of(context).bDropdownTheme;

    return BDropdownID<T, ID>(
      value: ValueNotifier(fieldValue),
      searchItems: getItems,
      toDisplay: toDisplay,
      onChanged: (value) => setChangedValue(formController, value),
      readOnly: isReadOnly(formTheme),
      onAdd: onAdd,
      callFutureOnStopWriting: callFutureOnStopWriting,
      boringDropdownLoadingMode: boringDropdownLoadingMode,
      searchable: searchable,
      boringDropdownStyle: dropdownStyle.copyWith(
        inputDecoration:
            getInputDecoration(formController, formTheme, error, fieldValue),
        onClearIcon: formTheme.eraseValueWidget,
        choiceItemDisplayTextStyle: formTheme.textStyle,
      ),
      clearable: clearable,
      errorMessage: error,
      debouncingTime: debouncingTime,
      initialItems: initialItems,
      loadingIndicator: loadingIndicator,
      identifier: identifier,
    );
  }

  @override
  Future<List<T>> onObservedFieldsChange(BoringFormController formController) =>
      getItems("");

  @override
  void onSelfChange(BoringFormController formController, ID? fieldValue) {}
}
