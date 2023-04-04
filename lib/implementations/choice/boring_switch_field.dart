// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:boring_form/field/boring_field_controller.dart';
import 'package:boring_form/theme/boring_field_decoration.dart';
import 'package:boring_form/theme/boring_responsive_size.dart';

import '../../field/boring_field.dart';
import '../../theme/boring_form_style.dart';
import '../../theme/boring_form_theme.dart';

enum BoringSwitchLabelPosition { left, right }

class BoringSwitchDecoration {
  final BorderRadius borderRadius;
  final double widthWhenActive;
  final double widthWhenNotActive;
  final Duration animationDuration;
  final Text? textWhenActive;
  final Text? textWhenNotActive;
  final Color? colorWhenActive;
  final Color? colorWhenNotActive;
  final double switchScale;
  final double heightFactor;
  final BoringSwitchLabelPosition labelPosition;
  final TextStyle? labelTextStlye;
  final double labelAndSwitchSpacing;
  final AlignmentGeometry alignment;

  BoringSwitchDecoration({
    this.borderRadius = const BorderRadius.all(
      Radius.circular(20),
    ),
    this.widthWhenActive = 105,
    this.widthWhenNotActive = 130,
    this.textWhenActive,
    this.textWhenNotActive,
    this.animationDuration = const Duration(milliseconds: 250),
    this.colorWhenActive,
    this.colorWhenNotActive,
    this.labelTextStlye,
    this.switchScale = 1,
    this.heightFactor = 1.7,
    this.alignment = Alignment.centerLeft,
    this.labelAndSwitchSpacing = 7,
    this.labelPosition = BoringSwitchLabelPosition.right,
  }) {
    if (textWhenActive != null) {
      assert(textWhenNotActive != null,
          "You need to provide both text when active and not active");
    }
    if (textWhenNotActive != null) {
      assert(textWhenActive != null,
          "You need to provide both text when active and not active");
    }
  }
}

class BoringSwitchField extends BoringField<bool> {
  BoringSwitchField(
      {super.key,
      required super.jsonKey,
      super.fieldController,
      super.decoration,
      super.displayCondition,
      super.boringResponsiveSize,
      super.onChanged,
      this.switchDecoration});

  final BoringSwitchDecoration? switchDecoration;

  @override
  Widget builder(BuildContext context, BoringFieldController<bool> controller,
      Widget? child) {
    final BoringFormStyle style = BoringFormTheme.of(context).style;
    bool readOnly = style.readOnly;
    bool hasLabel = decoration?.label != null ||
        (switchDecoration?.textWhenActive == null &&
            switchDecoration?.textWhenNotActive == null);

    return BoringField.boringFieldBuilder(
      style,
      decoration?.label ?? '',
      child: Align(
        alignment: switchDecoration?.alignment ?? Alignment.centerLeft,
        heightFactor: switchDecoration?.heightFactor ?? 1.7,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection:
              switchDecoration?.labelPosition == BoringSwitchLabelPosition.right
                  ? TextDirection.ltr
                  : TextDirection.rtl,
          children: [
            MouseRegion(
              cursor: readOnly ? MouseCursor.defer : SystemMouseCursors.click,
              child: _AnimatedCustomSwitch(
                controller: controller,
                switchDecoration: switchDecoration ?? BoringSwitchDecoration(),
                fieldDecoration: decoration,
                hasLabel: hasLabel,
              ),
            ),
            if (hasLabel)
              Padding(
                padding: EdgeInsets.only(
                  left: switchDecoration?.labelPosition ==
                          BoringSwitchLabelPosition.right
                      ? switchDecoration?.labelAndSwitchSpacing ?? 0
                      : 0,
                  right: switchDecoration?.labelPosition !=
                          BoringSwitchLabelPosition.right
                      ? switchDecoration?.labelAndSwitchSpacing ?? 0
                      : 0,
                ),
                child: Text(
                  decoration?.label ?? '',
                  style: switchDecoration?.labelTextStlye ??
                      Theme.of(context).textTheme.titleMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  BoringField copyWith(
      {BoringFieldController<bool>? fieldController,
      void Function(bool? p1)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic> p1)? displayCondition,
      BoringSwitchDecoration? switchDecoration}) {
    return BoringSwitchField(
      jsonKey: jsonKey ?? this.jsonKey,
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      decoration: decoration ?? this.decoration,
      displayCondition: displayCondition ?? this.displayCondition,
      fieldController: fieldController ?? this.fieldController,
      onChanged: onChanged ?? this.onChanged,
      switchDecoration: switchDecoration ?? this.switchDecoration,
    );
  }
}

class _AnimatedCustomSwitch extends StatefulWidget {
  const _AnimatedCustomSwitch({
    required this.controller,
    required this.switchDecoration,
    required this.hasLabel,
    this.fieldDecoration,
  });

  final BoringFieldController controller;
  final BoringSwitchDecoration switchDecoration;
  final BoringFieldDecoration? fieldDecoration;
  final bool hasLabel;

  @override
  State<_AnimatedCustomSwitch> createState() => _AnimatedCustomSwitchState();
}

class _AnimatedCustomSwitchState extends State<_AnimatedCustomSwitch> {
  @override
  Widget build(BuildContext context) {
    final BoringFormStyle style = BoringFormTheme.of(context).style;
    final TextStyle bold = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontWeight: FontWeight.w600);
    bool active = widget.controller.value ?? false;

    final colorWhenActive = widget.switchDecoration.colorWhenActive ??
        Theme.of(context).colorScheme.primary;
    final colorWhenNotActive = widget.switchDecoration.colorWhenNotActive ??
        Theme.of(context).colorScheme.error;

    return DefaultTextStyle(
      style: bold,
      child: Transform.scale(
        scale: widget.switchDecoration.switchScale,
        child: GestureDetector(
          onTap: style.readOnly
              ? null
              : () {
                  widget.controller.value = !(widget.controller.value ?? false);
                  // ! IMPORTANTE
                  widget.controller.sendNotification();
                },
          child: AnimatedContainer(
            duration: widget.switchDecoration.animationDuration,
            width: widget.hasLabel
                ? 70
                : active
                    ? widget.switchDecoration.widthWhenActive
                    : widget.switchDecoration.widthWhenNotActive,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: active ? colorWhenActive : colorWhenNotActive,
                borderRadius: widget.switchDecoration.borderRadius),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!widget.hasLabel)
                  AnimatedCrossFade(
                      firstCurve: Curves.ease,
                      secondCurve: Curves.ease,
                      sizeCurve: Curves.ease,
                      firstChild: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: widget.switchDecoration.textWhenActive,
                        ),
                      ),
                      secondChild: Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: widget.switchDecoration.textWhenNotActive),
                      ),
                      crossFadeState: active
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: widget.switchDecoration.animationDuration),
                AnimatedAlign(
                  alignment:
                      active ? Alignment.centerRight : Alignment.centerLeft,
                  duration: widget.switchDecoration.animationDuration,
                  curve: Curves.ease,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: widget.switchDecoration.borderRadius,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
