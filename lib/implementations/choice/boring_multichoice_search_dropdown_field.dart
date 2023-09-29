// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/field/boring_field_controller.dart';
import 'package:boring_form/theme/boring_field_decoration.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_form/theme/boring_responsive_size.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class BoringSearchMultiChoiceDropDownField<T> extends BoringField<List<T>> {
  BoringSearchMultiChoiceDropDownField(
      {super.key,
      required super.jsonKey,
      required this.items,
      required this.convertItemToString,
      this.searchInputDecoration,
      bool? readOnly,
      this.radius = 0,
      this.checkedIcon,
      this.onAdd,
      this.dropdownItemsSpaceBetweenIcon,
      this.uncheckedIcon,
      this.itemsPadding,
      this.resultTextPadding,
      this.itemsTextStyle,
      this.onItemAlreadyExisting,
      this.onAddIcon = const Icon(Icons.add),
      this.resultTextStyle,
      this.searchMatchFunction,
      super.fieldController,
      super.decoration,
      super.displayCondition,
      super.boringResponsiveSize,
      super.onChanged,
      this.showEraseValueButton = true})
      : _itemsNotifier = ValueNotifier(items),
        super(readOnly: readOnly);

  //final List<DropdownMenuItem<T?>> items;
  final List<T> items;
  final InputDecoration? searchInputDecoration;
  final String Function(T item) convertItemToString;
  final double radius;
  final Widget? checkedIcon;
  final Widget? uncheckedIcon;
  final TextStyle? resultTextStyle;
  final TextStyle? itemsTextStyle;
  final EdgeInsets? itemsPadding;
  final EdgeInsets? resultTextPadding;
  final double? dropdownItemsSpaceBetweenIcon;
  final FutureOr<void> Function(BuildContext dropdownContext)?
      onItemAlreadyExisting;
  final bool Function(DropdownMenuItem<dynamic>, String)? searchMatchFunction;
  final searchEditController = TextEditingController();
  final FutureOr<T?> Function(String searchTextFieldValue)? onAdd;
  final GlobalKey _dropdownKey = GlobalKey();
  final ValueNotifier<List<T?>> _itemsNotifier;
  final bool showEraseValueButton;
  final Widget onAddIcon;

  _searchMatchFn(item, searchValue) =>
      searchMatchFunction?.call(item, searchValue) ??
      item.value.toString().toLowerCase().contains(searchValue.toLowerCase());

  _onMenuStateChange(isOpen, searchEditController) =>
      !isOpen ? searchEditController.clear() : null;

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;

    final InputDecoration newStyle = getDecoration(context)
        .copyWith(contentPadding: const EdgeInsets.all(0));

    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: ValueListenableBuilder(
          valueListenable: controller.autoValidate
              ? ValueNotifier(false)
              : controller.hideError,
          builder: (BuildContext context, bool value, Widget? child) {
            final InputDecoration newStyle =
                getDecoration(context, haveError: value)
                    .copyWith(contentPadding: const EdgeInsets.all(0));
            return Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField2<T?>(
                    key: _dropdownKey,
                    dropdownOverButton: false,
                    dropdownElevation: 0,
                    decoration: newStyle,
                    buttonHeight: 50,
                    itemHeight: 50,
                    searchInnerWidgetHeight: 20,
                    searchController: searchEditController,
                    dropdownMaxHeight: 250,
                    items: _buildItems(controller, context, isReadOnly),
                    searchInnerWidget: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          if (onAdd != null) ...[
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () async {
                                  await _onAdd(
                                      _dropdownKey.currentContext!, controller);
                                },
                                child: onAddIcon,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                          Expanded(
                            child: TextFormField(
                              controller: searchEditController,
                              decoration: searchInputDecoration,
                            ),
                          ),
                        ],
                      ),
                    ),
                    value:
                        controller.value != null && controller.value!.isNotEmpty
                            ? controller.value?.first
                            : null,
                    hint: Text(
                      decoration?.hintText ?? '',
                      style: style.inputDecoration.hintStyle,
                    ),
                    dropdownDecoration: _boxDecoration(newStyle),
                    onChanged: isReadOnly(context) ? null : (value) {},
                    isExpanded: true,
                    onMenuStateChange: (isOpen) =>
                        _onMenuStateChange(isOpen, searchEditController),
                    itemPadding: itemsPadding ??
                        const EdgeInsets.symmetric(horizontal: 15.0),
                    selectedItemBuilder: (context) {
                      return items.map(
                        (item) {
                          return Container(
                            alignment: AlignmentDirectional.centerStart,
                            padding: resultTextPadding ??
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Text(
                              controller.value
                                      ?.map((e) => convertItemToString(e))
                                      .join(', ') ??
                                  '',
                              style: resultTextStyle?.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                  ) ??
                                  const TextStyle(
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              maxLines: 1,
                            ),
                          );
                        },
                      ).toList();
                    },
                  ),
                ),
                if (showEraseValueButton && controller.value != null) ...[
                  const SizedBox(width: 5),
                  eraseButtonWidget(context, style.eraseValueWidget),
                ],
              ],
            );
          }),
    );
  }

  _onAdd(BuildContext dialogContext,
      BoringFieldController<List<T?>> controller) async {
    if (searchEditController.text.isNotEmpty) {
      final newList = _itemsNotifier.value;
      final item = await onAdd!.call(searchEditController.text);
      if (item != null) {
        for (var e in newList) {
          if (e == item) {
            onItemAlreadyExisting?.call(_dropdownKey.currentContext!);
            return;
          }
        }
        newList.add(item);
        _itemsNotifier.value = newList;

        controller.value ??= <T>[];
        controller.value?.add(item);
        controller.sendNotification();

        Navigator.pop(_dropdownKey.currentContext!);
      }
    }
  }

  _buildItems(BoringFieldController<List<T>> controller, BuildContext context,
      bool Function(BuildContext) isReadOnly) {
    return items
        .map(
          (e) => DropdownMenuItem<T>(
            value: e,
            enabled: false,
            child: StatefulBuilder(
              builder: (context, menuState) {
                final _isSelected = controller.value?.contains(e) ?? false;

                return InkWell(
                  onTap: () {
                    late List<T> newValues = controller.value ?? [];
                    if (_isSelected && newValues.contains(e)) {
                      newValues.remove(e);
                    } else {
                      newValues.add(e);
                    }

                    controller.value = newValues;

                    menuState(() {});
                  },
                  child: SizedBox(
                    height: double.infinity,
                    child: Row(
                      children: [
                        _isSelected
                            ? checkedIcon ??
                                const Icon(Icons.check_box_outlined)
                            : uncheckedIcon ??
                                const Icon(Icons.check_box_outline_blank),
                        SizedBox(width: dropdownItemsSpaceBetweenIcon ?? 16),
                        Flexible(
                          child: Text(
                            convertItemToString(e),
                            overflow: TextOverflow.ellipsis,
                            style: itemsTextStyle ??
                                const TextStyle(
                                  fontSize: 14,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
        .toList();
  }

  _boxDecoration(InputDecoration newStyle) => BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: newStyle.fillColor ?? Colors.white,
      border: Border.all(
          color: newStyle.border?.borderSide.color ?? Colors.grey,
          width: newStyle.border?.borderSide.width ?? 1));

  @override
  BoringField copyWith({
    BoringFieldController<List<T>>? fieldController,
    void Function(List<T>? p1)? onChanged,
    BoringFieldDecoration? decoration,
    BoringResponsiveSize? boringResponsiveSize,
    String? jsonKey,
    bool Function(Map<String, dynamic> p1)? displayCondition,
    List<T>? items,
    String Function(T item)? convertItemToString,
    InputDecoration? searchInputDecoration,
    double? radius,
  }) {
    return BoringSearchMultiChoiceDropDownField(
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      jsonKey: jsonKey ?? this.jsonKey,
      searchInputDecoration:
          searchInputDecoration ?? this.searchInputDecoration,
      decoration: decoration ?? this.decoration,
      onChanged: (onChanged as void Function(dynamic)?) ??
          (this.onChanged as void Function(dynamic)),
      displayCondition: displayCondition ?? this.displayCondition,
      fieldController: fieldController ?? this.fieldController,
      items: items ?? this.items,
      convertItemToString: convertItemToString ?? this.convertItemToString,
    );
  }
}
