import 'package:boring_form/boring_form.dart';
import 'package:flutter/material.dart';

abstract class BoringField<T> extends StatelessWidget {
  final String jsonKey;
  final BoringFieldControllerInterface<T> controller;
  final void Function(T?)? onChanged;
  final BoringFieldDecoration? decoration;
  final BoringResponsiveSize boringResponsiveSize;
  final bool? readOnly;
  final bool Function(Map<String, dynamic> formValue)? displayCondition;
  BoringField(
      {super.key,
      required this.jsonKey,
      BoringFieldController<T>? controller,
      this.onChanged,
      this.decoration,
      this.boringResponsiveSize = const BoringResponsiveSize(),
      this.readOnly,
      this.displayCondition})
      : controller = (controller ?? BoringFieldController<T>()),
        assert(!jsonKey.contains('.'), "JsonKey cannot contain '.'") {
    // controller?.addListener(_onChangedValue);
    // setInitialValue(this.controller.initialValue);
  }

  // factory BoringField.onChanged(
  //     void Function(T?)? onChanged,
  //     BoringFieldDecoration? decoration,
  //     BoringResponsiveSize? boringResponsiveSize,
  //     String? jsonKey,
  //     bool Function(Map<String, dynamic>)? displayCondition}
  //  ) {
  //   // controller?.addListener(_onChangedValue);
  //   // setInitialValue(this.controller.initialValue);
  //   return
  // }

  // BoringField copyWith(
  //     {BoringFieldController<T>? fieldController,
  //     void Function(T?)? onChanged,
  //     BoringFieldDecoration? decoration,
  //     BoringResponsiveSize? boringResponsiveSize,
  //     String? jsonKey,
  //     bool Function(Map<String, dynamic>)? displayCondition});

  // bool _ignoreInitialValue(T? value) => value != null;

  // final contextHolder = ValueHolder<BuildContext>();

  // void _onChangedValue() {
  //   //onValueChanged(fieldController.value);
  //   onChanged?.call(fieldController.value);
  //   if (contextHolder.value != null) {
  //     FieldChangeNotification().dispatch(contextHolder.value);
  //   }
  // }

  BoringFormTheme getTheme(BuildContext context) => BoringFormTheme.of(context);

  BoringFormStyle getStyle(BuildContext context) => getTheme(context).style;

  // InputDecoration getDecoration(BuildContext context, {bool haveError = true}) {
  //   final style = getStyle(context);
  //   if (!haveError) {
  //     return style.inputDecoration.copyWith(
  //         labelText: (style.labelOverField || decoration?.label == null)
  //             ? null
  //             : decoration?.label,
  //         icon: decoration?.icon,
  //         errorText: fieldController.errorMessage,
  //         helperText: decoration?.helperText,
  //         hintText: decoration?.hintText,
  //         prefix: decoration?.prefix,
  //         prefixIcon: decoration?.prefixIcon,
  //         prefixText: decoration?.prefixText,
  //         suffix: decoration?.suffix,
  //         suffixIcon: decoration?.suffixIcon,
  //         suffixText: decoration?.suffixText,
  //         counter: decoration?.counter?.call(fieldController.value));
  //   } else {
  //     return style.inputDecoration.copyWith(
  //         labelText: (style.labelOverField || decoration?.label == null)
  //             ? null
  //             : decoration?.label,
  //         icon: decoration?.icon,
  //         helperText: decoration?.helperText,
  //         hintText: decoration?.hintText,
  //         prefix: decoration?.prefix,
  //         prefixIcon: decoration?.prefixIcon,
  //         prefixText: decoration?.prefixText,
  //         suffix: decoration?.suffix,
  //         suffixIcon: decoration?.suffixIcon,
  //         suffixText: decoration?.suffixText,
  //         counter: decoration?.counter?.call(fieldController.value));
  //   }
  // }

  bool isReadOnly(BuildContext context) =>
      (readOnly != null) ? readOnly! : getStyle(context).readOnly;

  static boringFieldBuilder(BoringFormStyle style, String? label,
      {required Widget child, bool? excludeLabel, EdgeInsets? padding}) {
    return Padding(
      padding: style.fieldsPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!(excludeLabel ?? false) && style.labelOverField && label != null)
            Padding(
              padding: padding ?? const EdgeInsets.only(bottom: 8, left: 4),
              child: Text(
                label,
                style: style.inputDecoration.labelStyle,
              ),
            ),
          child
        ],
      ),
    );
  }

  //void onValueChanged(T? newValue);

  Widget builder(
    BuildContext context,
    BoringFieldControllerInterface<T> controller,
  );

  // bool setInitialValue(T? initialValue) {
  //   if (!_ignoreInitialValue(initialValue) &&
  //       fieldController.initialValue != null) {
  //     return false;
  //   }

  //   fieldController.initialValue = initialValue;
  //   fieldController.value ??= initialValue;

  //   return true;
  // }

  // Widget eraseButtonWidget(BuildContext context, Widget eraseButtonWidget,
  //         [Function()? moreActions]) =>
  //     isReadOnly(context)
  //         ? Container()
  //         : MouseRegion(
  //             cursor: SystemMouseCursors.click,
  //             child: GestureDetector(
  //               onTap: () {
  //                 fieldController.value = null;
  //                 moreActions?.call();
  //               },
  //               child: eraseButtonWidget,
  //             ),
  //           );

  @override
  Widget build(BuildContext context) {
    // controller.fieldContext = context;
    return builder(context, controller);
  }
}
