import 'dart:async';

import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringDropdownField<V, T> extends BFormFieldAsync<V, List<T>> {
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
    super.onChanged,
    super.required,
    super.responsiveSize,
  });

  final Future<List<T>> Function(String search) getItems;
  final BChoiceItem<V> Function(T element) toBoringChoiceItem;

  final FutureOr<T?> Function(String)? onAdd;
  final bool callFutureOnStopWriting;
  final bool searchable;
  final BDropdownTheme? boringDropdownStyle;
  final BDropdownLoadingMode boringDropdownLoadingMode;
  final bool clearable;
  final Duration debouncingTime;
  final Widget loadingIndicator;

  @override
  Future<List<T>?> Function(Map<FieldPath, dynamic> observedValues)?
      get asyncComputations => (observedValues) => getItems("");

  @override
  Widget fieldBuilder(
    BuildContext context,
    BoringFormStyle formStyle,
    BFormController formController,
    V? fieldValue,
    FieldValidation fieldValidation,
    List<T>? computedValue,
  ) {
    final dropdownStyle =
        boringDropdownStyle ?? BoringTheme.of(context).bDropdownTheme;

    return BDropdown<V, T>(
      value: fieldValue != null ? [fieldValue] : [],
      valueNotifier: ValueNotifier([]),
      searchItems: getItems,
      toDisplay: (v) => toBoringChoiceItem(v).display,
      onChanged: (value) => setChangedValue(formController, value.firstOrNull),
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
      errorMessage: fieldValidation.showError ? fieldValidation.error : null,
      debouncingTime: debouncingTime,
      initialItems:
          AsyncSnapshot.withData(ConnectionState.done, computedValue ?? []),
      loadingIndicator: loadingIndicator,
      elemToValue: (elem) => toBoringChoiceItem(elem).value,
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
