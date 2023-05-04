import 'package:boring_form/boring_form.dart';
import 'package:flutter/material.dart';

class BoringSideFieldDecoration {
  Color? backgroundColor;
  double? radius;
  EdgeInsets? padding;
  double? spacing;
  TextStyle? labelTextStyle;
  int labelFlex;
  int fieldFlex;

  BoringSideFieldDecoration({
    this.backgroundColor,
    this.radius,
    this.padding,
    this.labelTextStyle,
    this.spacing,
    this.labelFlex = 1,
    this.fieldFlex = 2,
  });

  BoringSideFieldDecoration copyWith(
      {Color? backgroundColor,
      double? radius,
      EdgeInsets? padding,
      TextStyle? labelTextStyle,
      double? spacing,
      int? labelFlex,
      int? fieldFlex}) {
    return BoringSideFieldDecoration(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      radius: radius ?? this.radius,
      padding: padding ?? this.padding,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      spacing: spacing ?? this.spacing,
      labelFlex: labelFlex ?? this.labelFlex,
      fieldFlex: fieldFlex ?? this.fieldFlex,
    );
  }
}

class BoringSideField<T> extends BoringField<T> {
  BoringField<T> field;
  BoringSideFieldDecoration? widgetDecoration;

  BoringSideField({
    required this.field,
    this.widgetDecoration,
    super.boringResponsiveSize,
    super.displayCondition,
  }) : super(
          jsonKey: field.jsonKey,
        );

  late Type t;

  @override
  Widget builder(
    BuildContext context,
    BoringFieldController<T> controller,
    Widget? child,
  ) {
    final style = getStyle(context);

    return BoringField.boringFieldBuilder(
      style,
      '',
      child: Container(
        padding: widgetDecoration?.padding ??
            const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: widgetDecoration?.backgroundColor,
          borderRadius: BorderRadius.circular(widgetDecoration?.radius ?? 15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (field.decoration != null && field.decoration!.label != null)
              Expanded(
                flex: widgetDecoration?.labelFlex ?? 1,
                child: Text(
                  field.decoration!.label!,
                  style: widgetDecoration?.labelTextStyle,
                ),
              ),
            SizedBox(
              width: widgetDecoration?.spacing ?? 100,
            ),
            Expanded(
              flex: widgetDecoration?.fieldFlex ?? 2,
              child: field.copyWith(
                onChanged: (p0) {
                  controller.setValueSilently(p0);
                },
                fieldController: BoringFieldController<T>(
                    initialValue: controller.initialValue),
                decoration: BoringFieldDecoration(
                  counter: field.decoration?.counter,
                  helperText: field.decoration?.helperText,
                  hintText: field.decoration?.hintText,
                  icon: field.decoration?.icon,
                  prefix: field.decoration?.prefix,
                  prefixIcon: field.decoration?.prefixIcon,
                  prefixText: field.decoration?.prefixText,
                  suffix: field.decoration?.suffix,
                  suffixIcon: field.decoration?.suffixIcon,
                  suffixText: field.decoration?.suffixText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  BoringField copyWith({
    BoringFieldController<T>? fieldController,
    void Function(T? p1)? onChanged,
    BoringFieldDecoration? decoration,
    BoringResponsiveSize? boringResponsiveSize,
    String? jsonKey,
    bool Function(Map<String, dynamic> p1)? displayCondition,
  }) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}
