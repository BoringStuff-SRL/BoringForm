// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/field/boring_field_controller.dart';
import 'package:boring_form/theme/boring_field_decoration.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_form/theme/boring_responsive_size.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class BoringSearchDropDownField<T> extends BoringField<T> {
  BoringSearchDropDownField(
      {super.key,
      required super.jsonKey,
      required this.items,
      this.onAdd,
      bool? readOnly,
      this.onItemAlreadyExisting,
      this.onAddIcon = const Icon(Icons.add),
      this.searchInputDecoration,
      this.radius = 0,
      this.isExpanded = false,
      this.searchMatchFunction,
      super.fieldController,
      super.decoration,
      super.displayCondition,
      super.boringResponsiveSize,
      super.onChanged})
      : _itemsNotifier = ValueNotifier(items),
        super(readOnly: readOnly);

  final InputDecoration? searchInputDecoration;
  final List<DropdownMenuItem<T?>> items;
  final ValueNotifier<List<DropdownMenuItem<T?>>> _itemsNotifier;
  final double radius;
  final searchEditController = TextEditingController();
  final bool isExpanded;
  final FutureOr<DropdownMenuItem<T>?> Function(String searchTextFieldValue)?
      onAdd;
  final FutureOr<void> Function(BuildContext dropdownContext)?
      onItemAlreadyExisting;
  final Widget onAddIcon;
  final bool Function(DropdownMenuItem<dynamic>, String)? searchMatchFunction;
  final GlobalKey _dropdownKey = GlobalKey();

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;

    final newStyle = getDecoration(context)
        .copyWith(contentPadding: const EdgeInsets.all(0));

    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: ValueListenableBuilder(
          valueListenable: _itemsNotifier,
          builder: (context, items, child) {
            return DropdownButtonFormField2<T?>(
              dropdownOverButton: false,
              key: _dropdownKey,
              isExpanded: isExpanded,
              searchInnerWidgetHeight: 20,
              dropdownElevation: 0,
              decoration: newStyle,
              buttonHeight: 50,
              itemHeight: 50,
              focusColor: Colors.transparent,
              buttonSplashColor: Colors.transparent,
              buttonHighlightColor: Colors.transparent,
              buttonOverlayColor: MaterialStateProperty.resolveWith((states) {
                return Colors.transparent;
              }),
              dropdownMaxHeight: 250,
              searchController: searchEditController,
              items: items,
              value: controller.value,
              hint: Text(
                decoration?.hintText ?? '',
                style: style.inputDecoration.hintStyle,
              ),
              dropdownDecoration: _boxDecoration(newStyle),
              onChanged: isReadOnly(context)
                  ? null
                  : ((value) {
                      controller.value = value;
                    }),
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
              searchMatchFn: (item, searchValue) =>
                  searchMatchFunction?.call(item, searchValue) ??
                  _searchDefaultMatchFn(item, searchValue),
              onMenuStateChange: (isOpen) =>
                  _onMenuStateChange(isOpen, searchEditController),
            );
          }),
    );
  }

  _onAdd(
      BuildContext dialogContext, BoringFieldController<T> controller) async {
    final newList = _itemsNotifier.value;
    final item = await onAdd!.call(searchEditController.text);
    if (item != null) {
      for (DropdownMenuItem element in newList) {
        if (element.value == item.value) {
          onItemAlreadyExisting?.call(_dropdownKey.currentContext!);
          return;
        }
      }
      newList.add(item);
      _itemsNotifier.value = newList;

      controller.value = item.value;
      Navigator.pop(_dropdownKey.currentContext!);
    }
  }

  _searchDefaultMatchFn(item, searchValue) =>
      item.value.toString().toLowerCase().contains(searchValue.toLowerCase());

  _onMenuStateChange(isOpen, searchEditController) =>
      !isOpen ? searchEditController.clear() : null;

  _boxDecoration(newStyle) => BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: newStyle.fillColor,
      border: Border.all(
          color: newStyle.border?.borderSide.color,
          width: newStyle.border?.borderSide.width));

  @override
  void onValueChanged(T? newValue) {}

  @override
  BoringSearchDropDownField copyWith(
      {BoringFieldController<T>? fieldController,
      void Function(T? p1)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic> p1)? displayCondition,
      List<DropdownMenuItem<dynamic>>? items,
      InputDecoration? searchInputDecoration,
      double? radius}) {
    return BoringSearchDropDownField(
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      jsonKey: jsonKey ?? this.jsonKey,
      decoration: decoration ?? this.decoration,
      onChanged: (onChanged as void Function(dynamic)?) ??
          (this.onChanged as void Function(dynamic)),
      displayCondition: displayCondition ?? this.displayCondition,
      fieldController: fieldController ?? this.fieldController,
      items: items ?? this.items,
      searchInputDecoration:
          searchInputDecoration ?? this.searchInputDecoration,
    );
  }
}
