// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/field/boring_field_controller.dart';
import 'package:boring_form/theme/boring_field_decoration.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_form/theme/boring_responsive_size.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class BoringMultiChoiceDropDownField<T> extends BoringField<List<T>> {
  BoringMultiChoiceDropDownField(
      {super.key,
      required super.jsonKey,
      required this.items,
      required this.convertItemToString,
      this.radius = 0,
      this.checkedIcon,
      this.dropdownItemsSpaceBetweenIcon,
      this.uncheckedIcon,
      this.itemsPadding,
      this.resultTextPadding,
      this.itemsTextStyle,
      this.resultTextStyle,
      super.fieldController,
      super.decoration,
      super.displayCondition,
      super.boringResponsiveSize,
      super.onChanged});

  //final List<DropdownMenuItem<T?>> items;
  final List<T> items;
  final String Function(T item) convertItemToString;
  final double radius;
  final Widget? checkedIcon;
  final Widget? uncheckedIcon;
  final TextStyle? resultTextStyle;
  final TextStyle? itemsTextStyle;
  final EdgeInsets? itemsPadding;
  final EdgeInsets? resultTextPadding;
  final double? dropdownItemsSpaceBetweenIcon;

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;

    final InputDecoration newStyle = getDecoration(context)
        .copyWith(contentPadding: const EdgeInsets.all(0));

    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: DropdownButtonFormField2<T?>(
        dropdownOverButton: false,
        dropdownElevation: 0,
        decoration: newStyle,
        buttonHeight: 50,
        itemHeight: 50,
        dropdownMaxHeight: 250,
        items: _buildItems(controller, context, isReadOnly),
        value: controller.value != null && controller.value!.isNotEmpty
            ? controller.value?.first
            : null,
        hint: Text(decoration?.hintText ?? ''),
        dropdownDecoration: _boxDecoration(newStyle),
        onChanged: isReadOnly(context) ? null : (value) {},
        isExpanded: true,
        itemPadding:
            itemsPadding ?? const EdgeInsets.symmetric(horizontal: 15.0),
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
    );
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
    return BoringMultiChoiceDropDownField(
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      jsonKey: jsonKey ?? this.jsonKey,
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
