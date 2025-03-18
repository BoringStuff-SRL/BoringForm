import 'dart:async';

import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringDropdownField<T> extends BFormFieldAsync<T, List<T>> {
  BoringDropdownField({
    super.key,
    required super.fieldPath,
    required this.getItems,
    super.decoration,
    super.observedFields,
    super.readOnly,
    super.validationFunction,
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
    super.onChanged,
    super.required,
  });

  final Future<List<T>> Function(String search) getItems;
  final BChoiceItem<T> Function(T element) toBoringChoiceItem;

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
  Future<List<T>?> asyncComputations(Map<FieldPath, dynamic> observedValues) {
    return getItems("");
  }

  @override
  Widget fieldBuilder(
    BuildContext context,
    BoringFormStyle formStyle,
    BoringFormController formController,
    T? fieldValue,
    FieldValidation fieldValidation,
    List<T>? computedValue,
  ) {
    final dropdownStyle =
        boringDropdownStyle ?? BoringTheme.of(context).bDropdownTheme;

    return BDropdown<T>(
      value: ValueNotifier(fieldValue),
      searchItems: getItems,
      toDisplay: (v) => toBoringChoiceItem(v).display,
      onChanged: (value) => setChangedValue(formController, value),
      readOnly: fieldValidation.isReadOnly,
      onAdd: onAdd,
      callFutureOnStopWriting: callFutureOnStopWriting,
      boringDropdownLoadingMode: boringDropdownLoadingMode,
      searchable: searchable,
      boringDropdownStyle: dropdownStyle.copyWith(
        inputDecoration: getInputDecoration(
            formController, formStyle, fieldValue, fieldValidation),
        onClearIcon: formStyle.eraseValueWidget,
        choiceItemDisplayTextStyle: formStyle.textStyle,
      ),
      clearable: clearable,
      errorMessage: fieldValidation.error,
      debouncingTime: debouncingTime,
      initialItems: initialItems,
      loadingIndicator: loadingIndicator,
    );
  }

  @override
  Widget onError(BuildContext context) {
    return const Text("ERRORE!");
  }

  @override
  Widget onLoading(BuildContext context) {
    return const BSkeleton.custom(child: TextField(readOnly: true));
  }
}
