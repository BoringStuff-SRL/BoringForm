import 'package:flutter/material.dart';

class BoringStepperDecoration {
  final double dialogWidth;
  final ShapeBorder? dialogShapeBorder;
  final EdgeInsets contentPadding;
  final Alignment buttonAlignment;
  final ButtonStyle? buttonStyle;
  final Text? actionButtonText;
  final Widget Function(ControlsDetails details)? onContinueButton;
  final Widget Function(ControlsDetails details)? onCancelButton;

  const BoringStepperDecoration({
    this.dialogWidth = 700,
    this.dialogShapeBorder,
    this.contentPadding = const EdgeInsets.all(10),
    this.buttonAlignment = Alignment.centerRight,
    this.buttonStyle,
    this.actionButtonText,
    this.onCancelButton,
    this.onContinueButton,
  });
}
