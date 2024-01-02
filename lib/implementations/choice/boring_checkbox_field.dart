// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/boring_form.dart';
import 'package:boring_form/field/boring_form_field.dart';
import 'package:flutter/material.dart';

class BoringCheckBoxField extends BoringFormField<bool> {
  const BoringCheckBoxField({
    super.key,
    required super.fieldPath,
    super.observedFields,
    super.validationFunction,
    super.decoration,
    super.readOnly,
    this.checkColor,
    this.mainAxisAlignment,
    this.unCheckColor,
    // this.verticalPositioning = 1,
    // super.displayCondition,
    // super.boringResponsiveSize,
    // super.onChanged
  });

  final Color? unCheckColor;
  final Color? checkColor;
  final MainAxisAlignment? mainAxisAlignment;
  // final double verticalPositioning;

  @override
  Widget builder(BuildContext context, BoringFormTheme formTheme,
      BoringFormController formController, bool? fieldValue, String? error) {
    final fieldDecoration = getFieldDecoration(formController);
    final inputDecoration =
        getInputDecoration(formController, formTheme, error, fieldValue);
    return Column(
      children: [
        GestureDetector(
          onTap: isReadOnly(formTheme)
              ? null
              : () => setChangedValue(formController,
                  !(formController.getValue(fieldPath) ?? false)),
          // {
          //     controller.value = !(controller.value ?? false);
          //   },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            children: [
              Container(
                child: (formController.getValue(fieldPath) as bool?) ?? false
                    ? Icon(Icons.check_box_rounded,
                        color: checkColor ?? inputDecoration.iconColor)
                    : Icon(Icons.check_box_outline_blank_rounded,
                        color: unCheckColor ?? inputDecoration.prefixIconColor),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Column(
                  children: [
                    Text(
                      fieldDecoration?.label ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              ((formController.getValue(fieldPath) as bool?) ??
                                      false)
                                  ? checkColor ?? inputDecoration.iconColor
                                  : unCheckColor ??
                                      inputDecoration.prefixIconColor),
                    ),
                    if (error != null) ...[
                      Text(error,
                          style: inputDecoration.errorStyle ??
                              const TextStyle(color: Colors.red)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        fieldDecoration?.helperText != null
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(fieldDecoration?.helperText ?? ""),
              )
            : Container(),
      ],
    );
  }

  @override
  void onObservedFieldsChange(BoringFormController formController) {}

  @override
  void onSelfChange(BoringFormController formController, bool? fieldValue) {}

  // @override
  // Widget builder(context, controller, child) {
  //   final BoringFormStyle style = BoringFormTheme.of(context).style;

  //   return BoringField.boringFieldBuilder(
  //     BoringFormStyle(),
  //     decoration?.label ?? '',
  //     child: Align(
  //       alignment: Alignment.center,
  //       heightFactor: verticalPositioning,
  //       child:
  //        Column(
  //         children: [
  //           GestureDetector(
  //             onTap: style.readOnly
  //                 ? null
  //                 : () {
  //                     controller.value = !(controller.value ?? false);
  //                   },
  //             child: Row(
  //               mainAxisSize: MainAxisSize.max,
  //               mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   child: controller.value ?? false
  //                       ? Icon(Icons.check_box_rounded,
  //                           color:
  //                               checkColor ?? style.inputDecoration.iconColor)
  //                       : Icon(Icons.check_box_outline_blank_rounded,
  //                           color: unCheckColor ??
  //                               style.inputDecoration.prefixIconColor),
  //                 ),
  //                 const SizedBox(
  //                   width: 8,
  //                 ),
  //                 Flexible(
  //                   child: Text(
  //                     decoration?.label! ?? '',
  //                     style: TextStyle(
  //                         fontWeight: FontWeight.w600,
  //                         color: controller.value ?? false
  //                             ? checkColor ?? style.inputDecoration.iconColor
  //                             : unCheckColor ??
  //                                 style.inputDecoration.prefixIconColor),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //           decoration?.helperText != null
  //               ? Padding(
  //                   padding: const EdgeInsets.only(left: 8.0),
  //                   child: Text(decoration!.helperText!),
  //                 )
  //               : Container(),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
