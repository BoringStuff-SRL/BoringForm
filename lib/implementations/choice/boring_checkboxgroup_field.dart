import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'boring_radiogroup_field.dart';

class BoringCheckBoxGroupField<T> extends BoringField<T> {
  BoringCheckBoxGroupField(
      {super.key,
      required super.jsonKey,
      required this.items,
      super.fieldController,
      super.decoration,
      this.itemsPerRow = 1,
      this.checkColor,
      this.unCheckColor,
      super.displayCondition,
      super.boringResponsiveSize,
      super.onChanged});

  final List<BoringChoiceItem<T>> items;
  final int itemsPerRow;
  final Color? unCheckColor;
  final Color? checkColor;

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;

    final initValue = (fieldController.value as bool?) ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(decoration?.label ?? ""),
          ),
          Wrap(
            children: items
                .map((item) => FractionallySizedBox(
                    widthFactor: 1 / itemsPerRow,
                    child: GestureDetector(
                      onTap: style.readOnly
                          ? null
                          : () => fieldController.value =
                              (!(fieldController.value as bool)) as T?,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: initValue
                                ? Icon(Icons.check_box_rounded,
                                    color: checkColor ??
                                        style.inputDecoration.iconColor)
                                : Icon(Icons.check_box_outline_blank_rounded,
                                    color: unCheckColor ??
                                        style.inputDecoration.prefixIconColor),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              item.display,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: initValue
                                      ? checkColor ??
                                          style.inputDecoration.iconColor
                                      : unCheckColor ??
                                          style
                                              .inputDecoration.prefixIconColor),
                            ),
                          )
                        ],
                      ),
                    )
/*
                    CheckboxListTile(
                          activeColor: style.inputDecoration.focusColor,
                          contentPadding: EdgeInsets.zero,
                          value: (fieldController.value as bool?) ?? false,
                          title: Text(item.display),
                          tristate: true,
                          onChanged: style.readOnly
                              ? null
                              : (checked) {
                                  /*
                                  if (checked == null) {
                                    return;
                                  }
                                  if (checked) {
                                    fieldController.value =
                                        fieldController.value == null
                                            ? [item.value as T]
                                            : fieldController.value!
                                          ..add(item.value as T);
                                  } else {
                                    fieldController.value =
                                        fieldController.value == null
                                            ? []
                                            : fieldController.value!
                                          ..remove(item.value as T);
                                  }
                               */
                                }),*/
                    ))
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(decoration?.helperText ?? ""),
          ),
        ],
      ),
    );
  }

  @override
  void onValueChanged(T? newValue) {}
}
