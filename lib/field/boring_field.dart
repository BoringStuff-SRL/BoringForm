import 'package:boring_form/boring_form.dart';
import 'package:boring_form/field/field_change_notification.dart';
import 'package:boring_form/utils/value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BoringField<T> extends StatelessWidget {
  BoringField(
      {super.key,
      BoringFieldController<T>? fieldController,
      this.onChanged,
      this.decoration,
      this.boringResponsiveSize = const BoringResponsiveSize(),
      this.readOnly,
      required this.jsonKey,
      this.displayCondition})
      : fieldController = (fieldController ?? BoringFieldController<T>()) {
    fieldController?.addListener(_onChangedValue);
    setInitialValue(this.fieldController.initialValue);
  }

  BoringField copyWith(
      {BoringFieldController<T>? fieldController,
      void Function(T?)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic>)? displayCondition});

  bool _ignoreInitialValue(T? value) => value != null;

  final BoringFieldController<T> fieldController;
  final void Function(T?)? onChanged;
  final String jsonKey;
  final BoringResponsiveSize boringResponsiveSize;
  final BoringFieldDecoration? decoration;
  final bool Function(Map<String, dynamic> formValue)? displayCondition;
  final contextHolder = ValueHolder<BuildContext>();
  bool? readOnly;

  void _onChangedValue() {
    //onValueChanged(fieldController.value);
    onChanged?.call(fieldController.value);
    if (contextHolder.value != null) {
      FieldChangeNotification().dispatch(contextHolder.value);
    }
  }

  BoringFormTheme getTheme(BuildContext context) => BoringFormTheme.of(context);

  BoringFormStyle getStyle(BuildContext context) => getTheme(context).style;

  InputDecoration getDecoration(BuildContext context) {
    final style = getStyle(context);
    return style.inputDecoration.copyWith(
        labelText: (style.labelOverField || decoration?.label == null)
            ? null
            : decoration?.label,
        icon: decoration?.icon,
        errorText: fieldController.errorMessage,
        helperText: decoration?.helperText,
        hintText: decoration?.hintText,
        prefix: decoration?.prefix,
        prefixIcon: decoration?.prefixIcon,
        prefixText: decoration?.prefixText,
        suffix: decoration?.suffix,
        suffixIcon: decoration?.suffixIcon,
        suffixText: decoration?.suffixText,
        counter: decoration?.counter?.call(fieldController.value));
  }

  bool isReadOnly(BuildContext context) =>
      (readOnly != null) ? readOnly! : getStyle(context).readOnly;

  static boringFieldBuilder(BoringFormStyle style, String? label,
      {required Widget child, bool? excludeLabel}) {
    return Padding(
      padding: style.fieldsPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!(excludeLabel ?? false) && style.labelOverField && label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 4),
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
    BoringFieldController<T> controller,
    Widget? child,
  );

  bool setInitialValue(T? initialValue) {
    if (!_ignoreInitialValue(initialValue) &&
        fieldController.initialValue != null) {
      return false;
    }

    fieldController.initialValue = initialValue;
    fieldController.value ??= initialValue;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    contextHolder.value = context;
    return ChangeNotifierProvider(
        create: (context) => fieldController,
        child: Consumer<BoringFieldController<T>>(
          builder: builder,
        ));
  }
}
