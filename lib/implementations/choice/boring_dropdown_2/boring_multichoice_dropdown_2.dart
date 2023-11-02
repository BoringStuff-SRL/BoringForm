import 'package:boring_dropdown/boring_dropdown_widget.dart';
import 'package:boring_form/boring_form.dart';
import 'package:flutter/material.dart';

class BoringMultichoiceDropdownField2<T> extends BoringField<List<T>> {
  BoringMultichoiceDropdownField2(
      {required super.jsonKey,
      required this.convertItemToString,
      required this.items,
      this.onAdd,
      this.onAddIcon,
      this.searchInputDecoration,
      this.showEraseValueButton = true,
      super.boringResponsiveSize,
      super.decoration,
      super.displayCondition,
      super.fieldController,
      super.key,
      super.onChanged,
      super.readOnly,
      this.checkedIcon,
      this.uncheckedIcon});

  final List<T> items;
  final String Function(T element) convertItemToString;
  final InputDecoration? searchInputDecoration;
  final Future<DropdownMenuItem<T>?> Function(BuildContext context)? onAdd;
  final Widget? onAddIcon;
  final bool showEraseValueButton;
  final Icon? checkedIcon;
  final Icon? uncheckedIcon;

  List<DropdownMenuItem<T>> get _dropdownItems => items
      .map((e) => DropdownMenuItem<T>(
          value: e, child: Text(convertItemToString.call(e))))
      .toList();

  @override
  Widget builder(BuildContext context,
      BoringFieldController<List<T>> controller, Widget? child) {
    final style = BoringFormTheme.of(context).style;
    return BoringField.boringFieldBuilder(
      style,
      super.decoration?.label,
      child: Row(
        children: [
          Expanded(
            child: BoringDropdown<T>.multichoice(
              items: _dropdownItems,
              checkedIcon: checkedIcon,
              unCheckedIcon: uncheckedIcon,
              convertItemToString: convertItemToString,
              searchInputDecoration: searchInputDecoration,
              onAdd: onAdd,
              onAddIcon: onAddIcon ?? const Icon(Icons.add),
              searchMatchFunction: (value, searchValue) => convertItemToString
                  .call(value)
                  .toLowerCase()
                  .trim()
                  .contains(searchValue.trim().toLowerCase()),
              validator: controller.validationFunction != null
                  ? (p0) {
                      return controller.validationFunction!(controller.value);
                    }
                  : null,
              autovalidateMode: controller.autoValidate
                  ? AutovalidateMode.always
                  : AutovalidateMode.onUserInteraction,
              onChanged: isReadOnly(context)
                  ? (e) {}
                  : (selectedElement) {
                      controller.value = selectedElement;
                    },
              inputDecoration: style.inputDecoration.copyWith(
                hintText: super.decoration?.hintText,
              ),
              value: controller.value,
              enabled: !isReadOnly(context),
            ),
          ),
          if (showEraseValueButton && controller.value != null) ...[
            const SizedBox(width: 5),
            eraseButtonWidget(context, style.eraseValueWidget),
          ],
        ],
      ),
    );
  }

  @override
  BoringMultichoiceDropdownField2<T> copyWith({
    BoringFieldController<List<T>>? fieldController,
    List<T>? items,
    void Function(List<T>? p1)? onChanged,
    BoringFieldDecoration? decoration,
    BoringResponsiveSize? boringResponsiveSize,
    String? jsonKey,
    String Function(T element)? convertItemToString,
    bool Function(Map<String, dynamic> p1)? displayCondition,
    Widget? onAddIcon,
    Future<DropdownMenuItem<T>?> Function(BuildContext context)? onAdd,
    bool? readOnly,
    InputDecoration? searchInputDecoration,
  }) {
    return BoringMultichoiceDropdownField2<T>(
      jsonKey: jsonKey ?? this.jsonKey,
      fieldController: fieldController ?? this.fieldController,
      convertItemToString: convertItemToString ?? this.convertItemToString,
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      decoration: decoration ?? this.decoration,
      displayCondition: displayCondition ?? this.displayCondition,
      items: items ?? this.items,
      onAddIcon: onAddIcon ?? this.onAddIcon,
      onAdd: onAdd ?? this.onAdd,
      readOnly: readOnly ?? this.readOnly,
      onChanged: onChanged ?? this.onChanged,
      searchInputDecoration:
          searchInputDecoration ?? this.searchInputDecoration,
    );
  }
}
