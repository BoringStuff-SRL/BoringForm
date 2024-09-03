// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:boring_form/field/boring_form_field.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum BoringSwitchLabelPosition { left, right, top }

// class BoringSwitchDecoration {
//   final BorderRadius borderRadius;
//   final double widthWhenActive;
//   final double widthWhenNotActive;
//   final Duration animationDuration;
//   final Text? textWhenActive;
//   final Text? textWhenNotActive;
//   final Color? colorWhenActive;
//   final Color? colorWhenNotActive;
//   final double switchScale;
//   final double heightFactor;
//   final BoringSwitchLabelPosition labelPosition;
//   final TextStyle? labelTextStlye;
//   final double labelAndSwitchSpacing;
//   final AlignmentGeometry alignment;

//   BoringSwitchDecoration({
//     this.borderRadius = const BorderRadius.all(
//       Radius.circular(20),
//     ),
//     this.widthWhenActive = 105,
//     this.widthWhenNotActive = 130,
//     this.textWhenActive,
//     this.textWhenNotActive,
//     this.animationDuration = const Duration(milliseconds: 250),
//     this.colorWhenActive,
//     this.colorWhenNotActive,
//     this.labelTextStlye,
//     this.switchScale = 1,
//     this.heightFactor = 1.7,
//     this.alignment = Alignment.centerLeft,
//     this.labelAndSwitchSpacing = 7,
//     this.labelPosition = BoringSwitchLabelPosition.top,
//   }) {
//     if (textWhenActive != null) {
//       assert(textWhenNotActive != null,
//           "You need to provide both text when active and not active");
//     }
//     if (textWhenNotActive != null) {
//       assert(textWhenActive != null,
//           "You need to provide both text when active and not active");
//     }
//   }
// }

class BoringSwitchDecoration {
  final Axis direction;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final ImageProvider<Object>? activeThumbImage;
  final void Function(Object, StackTrace?)? onActiveThumbImageError;
  final ImageProvider<Object>? inactiveThumbImage;
  final void Function(Object, StackTrace?)? onInactiveThumbImageError;
  final MaterialStateProperty<Color?>? thumbColor;
  final MaterialStateProperty<Color?>? trackColor;
  final MaterialStateProperty<Color?>? trackOutlineColor;
  final MaterialStateProperty<double?>? trackOutlineWidth;
  final MaterialStateProperty<Icon?>? thumbIcon;
  final MaterialTapTargetSize? materialTapTargetSize;
  final DragStartBehavior dragStartBehavior;
  final MouseCursor? mouseCursor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;

  const BoringSwitchDecoration({
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.onActiveThumbImageError,
    this.inactiveThumbImage,
    this.onInactiveThumbImageError,
    this.thumbColor,
    this.trackColor,
    this.trackOutlineColor,
    this.trackOutlineWidth,
    this.thumbIcon,
    this.materialTapTargetSize,
    this.dragStartBehavior = DragStartBehavior.start,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.direction = Axis.horizontal,
  });
  // FocusNode? focusNode;
  // void Function(bool)? onFocusChange,
  // bool autofocus = false,
}

class BoringSwitchField extends BoringFormField<bool> {
  const BoringSwitchField({
    super.key,
    required super.fieldPath,
    super.observedFields,
    super.onChanged,
    super.readOnly,
    super.decoration,
    required this.inputDecoration,
    this.switchDecoration = const BoringSwitchDecoration(),
  });

  final BoringSwitchDecoration switchDecoration;
  final InputDecoration inputDecoration;

  @override
  Widget builder(BuildContext context, BoringFormStyle formStyle,
      BoringFormController formController, bool? fieldValue, String? error) {
    return _SwitchWithDecoration(
      readOnly: isReadOnly(formStyle),
      value: formController.getValue(fieldPath) ?? false,
      onChanged: (value) {
        setChangedValue(formController, (value ?? false));
      },
      switchDecoration: switchDecoration,
      decoration: getFieldDecoration(formController),
      inputDecoration:
          getInputDecoration(formController, formStyle, error, fieldValue),
    );
  }

  @override
  void onObservedFieldsChange(BoringFormController formController) {}

  @override
  void onSelfChange(BoringFormController formController, bool? fieldValue) {}
}

class _SwitchWithDecoration extends StatelessWidget {
  final Function(bool?) onChanged;
  final bool value;
  final bool readOnly;
  final BoringSwitchDecoration switchDecoration;
  final BoringFieldDecoration<bool>? decoration;
  final InputDecoration inputDecoration;

  _SwitchWithDecoration({
    Key? key,
    required this.onChanged,
    required this.value,
    required this.readOnly,
    required this.decoration,
    required this.inputDecoration,
    this.switchDecoration = const BoringSwitchDecoration(),
  })  : switchValue = ValueNotifier<bool>(value),
        super(key: key);

  String? get label => decoration?.label;
  final ValueNotifier<bool> switchValue;
  TextStyle get labelStyle => inputDecoration.labelStyle ?? const TextStyle();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: readOnly,
      child: Wrap(
        direction: switchDecoration.direction,
        children: [
          label != null
              ? ValueListenableBuilder(
                  valueListenable: switchValue,
                  builder: (context, value, child) => Text(
                    label!,
                    style: labelStyle.copyWith(
                      color: value ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                )
              : const SizedBox(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: switchDecoration.activeColor,
            activeTrackColor: switchDecoration.activeTrackColor,
            inactiveThumbColor: switchDecoration.inactiveThumbColor,
            inactiveTrackColor: switchDecoration.inactiveTrackColor,
            activeThumbImage: switchDecoration.activeThumbImage,
            onActiveThumbImageError: switchDecoration.onActiveThumbImageError,
            inactiveThumbImage: switchDecoration.inactiveThumbImage,
            onInactiveThumbImageError:
                switchDecoration.onInactiveThumbImageError,
            thumbColor: switchDecoration.thumbColor,
            trackColor: switchDecoration.trackColor,
            trackOutlineColor: switchDecoration.trackColor,
            trackOutlineWidth: switchDecoration.trackOutlineWidth,
            thumbIcon: switchDecoration.thumbIcon,
            materialTapTargetSize: switchDecoration.materialTapTargetSize,
            dragStartBehavior: switchDecoration.dragStartBehavior,
            mouseCursor: switchDecoration.mouseCursor,
            focusColor: switchDecoration.focusColor,
            hoverColor: switchDecoration.hoverColor,
            overlayColor: switchDecoration.overlayColor,
            splashRadius: switchDecoration.splashRadius,
          ),
        ],
      ),
    );
  }
}

// class _AnimatedCustomSwitch extends StatefulWidget {
//   const _AnimatedCustomSwitch({
//     required this.controller,
//     required this.switchDecoration,
//     required this.hasLabel,
//   });

//   final BoringFieldController controller;
//   final BoringSwitchDecoration switchDecoration;
//   final BoringFieldDecoration? fieldDecoration;
//   final bool hasLabel;

//   @override
//   State<_AnimatedCustomSwitch> createState() => _AnimatedCustomSwitchState();
// }

// class _AnimatedCustomSwitchState extends State<_AnimatedCustomSwitch> {
//   @override
//   Widget build(BuildContext context) {
//     final BoringFormStyle style = BoringFormTheme.of(context).style;
//     final TextStyle bold = Theme.of(context)
//         .textTheme
//         .bodyLarge!
//         .copyWith(fontWeight: FontWeight.w600);
//     bool active = widget.controller.value ?? false;

//     final colorWhenActive = widget.switchDecoration.colorWhenActive ??
//         Theme.of(context).colorScheme.primary;
//     final colorWhenNotActive = widget.switchDecoration.colorWhenNotActive ??
//         Theme.of(context).colorScheme.error;

//     return DefaultTextStyle(
//       style: bold,
//       child: Transform.scale(
//         scale: widget.switchDecoration.switchScale,
//         child: GestureDetector(
//           onTap: style.readOnly
//               ? null
//               : () {
//                   widget.controller.value = !(widget.controller.value ?? false);
//                   // ! IMPORTANTE
//                   widget.controller.sendNotification();
//                 },
//           child: AnimatedContainer(
//             duration: widget.switchDecoration.animationDuration,
//             width: widget.hasLabel
//                 ? 70
//                 : active
//                     ? widget.switchDecoration.widthWhenActive
//                     : widget.switchDecoration.widthWhenNotActive,
//             padding: const EdgeInsets.all(7),
//             decoration: BoxDecoration(
//                 color: active ? colorWhenActive : colorWhenNotActive,
//                 borderRadius: widget.switchDecoration.borderRadius),
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 AnimatedCrossFade(
//                     firstCurve: Curves.ease,
//                     secondCurve: Curves.ease,
//                     sizeCurve: Curves.ease,
//                     firstChild: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 3),
//                         child: widget.switchDecoration.textWhenActive,
//                       ),
//                     ),
//                     secondChild: Padding(
//                       padding: const EdgeInsets.only(right: 3),
//                       child: Align(
//                           alignment: Alignment.centerRight,
//                           child: widget.switchDecoration.textWhenNotActive),
//                     ),
//                     crossFadeState: active
//                         ? CrossFadeState.showFirst
//                         : CrossFadeState.showSecond,
//                     duration: widget.switchDecoration.animationDuration),
//                 AnimatedAlign(
//                   alignment:
//                       active ? Alignment.centerRight : Alignment.centerLeft,
//                   duration: widget.switchDecoration.animationDuration,
//                   curve: Curves.ease,
//                   child: Container(
//                     height: 20,
//                     width: 20,
//                     decoration: BoxDecoration(
//                         borderRadius: widget.switchDecoration.borderRadius,
//                         color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
