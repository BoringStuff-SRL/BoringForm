// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/boring_form.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:flutter/material.dart';

class BoringCheckBoxField extends BoringField<bool> {
  BoringCheckBoxField(
      {super.key,
      required super.jsonKey,
      super.fieldController,
      super.decoration,
      this.checkColor,
      this.mainAxisAlignment,
      this.unCheckColor,
      this.verticalPositioning = 1,
      super.displayCondition,
      super.boringResponsiveSize,
      super.onChanged});

  final Color? unCheckColor;
  final Color? checkColor;
  final MainAxisAlignment? mainAxisAlignment;
  final double verticalPositioning;

  @override
  Widget builder(context, controller, child) {
    final BoringFormStyle style = BoringFormTheme.of(context).style;

    return BoringField.boringFieldBuilder(
      BoringFormStyle(),
      decoration?.label ?? '',
      child: Align(
        alignment: Alignment.center,
        heightFactor: verticalPositioning,
        child: Column(
          children: [
            GestureDetector(
              onTap: style.readOnly
                  ? null
                  : () {
                      controller.value = !(controller.value ?? false);
                    },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
                children: [
                  Container(
                    child: controller.value ?? false
                        ? Icon(Icons.check_box_rounded,
                            color:
                                checkColor ?? style.inputDecoration.iconColor)
                        : Icon(Icons.check_box_outline_blank_rounded,
                            color: unCheckColor ??
                                style.inputDecoration.prefixIconColor),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      decoration?.label! ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: controller.value ?? false
                              ? checkColor ?? style.inputDecoration.iconColor
                              : unCheckColor ??
                                  style.inputDecoration.prefixIconColor),
                    ),
                  )
                ],
              ),
            ),
            decoration?.helperText != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(decoration!.helperText!),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void onValueChanged(bool? newValue) {}

  @override
  BoringCheckBoxField copyWith(
      {BoringFieldController<bool>? fieldController,
      void Function(bool? p1)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic> p1)? displayCondition,
      List<BoringChoiceItem<dynamic>>? items,
      MainAxisAlignment? mainAxisAlignment,
      int? itemsPerRow,
      Color? checkColor,
      Color? unCheckColor}) {
    return BoringCheckBoxField(
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      jsonKey: jsonKey ?? this.jsonKey,
      decoration: decoration ?? this.decoration,
      onChanged: onChanged ?? this.onChanged,
      displayCondition: displayCondition ?? this.displayCondition,
      fieldController: fieldController ?? this.fieldController,
      checkColor: checkColor ?? this.checkColor,
      unCheckColor: unCheckColor ?? this.unCheckColor,
    );
  }
}
