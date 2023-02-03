import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class BoringSearchDropDownField<T> extends BoringField<T> {
  BoringSearchDropDownField(
      {super.key,
      required super.jsonKey,
      required this.items,
      this.searchInputDecoration,
      this.radius = 0,
      super.fieldController,
      super.decoration,
      super.displayCondition,
      super.boringResponsiveSize,
      super.onChanged});

  final InputDecoration? searchInputDecoration;
  final List<DropdownMenuItem<T?>> items;
  final double radius;
  final searchEditController = TextEditingController();

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;

    final newStyle =
        style.inputDecoration.copyWith(contentPadding: const EdgeInsets.all(0));

    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: DropdownButtonFormField2<T?>(
        dropdownOverButton: false,
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
        hint: Text(decoration?.hintText ?? ''),
        dropdownDecoration: _boxDecoration(newStyle),
        onChanged: isReadOnly(context)
            ? null
            : ((value) {
                controller.value = value;
              }),
        searchInnerWidget: Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: searchEditController,
            decoration: searchInputDecoration,
          ),
        ),
        searchMatchFn: (item, searchValue) => _searchMatchFn(item, searchValue),
        onMenuStateChange: (isOpen) =>
            _onMenuStateChange(isOpen, searchEditController),
      ),
    );
  }

  _searchMatchFn(item, searchValue) =>
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
}
