import 'package:flutter/material.dart';

class BoringStepperStyle {
  final String onContinueText;
  final String onCancelText;
  final TextStyle? titleTextStyle;
  final TextStyle? subTitleTextStyle;
  final ButtonStyle? onCancelButtonStyle;
  final ButtonStyle? onContinueButtonStyle;
  final StepperType stepperType;

  const BoringStepperStyle({
    this.onCancelText = 'Cancel',
    this.onContinueText = 'Continue',
    this.titleTextStyle,
    this.subTitleTextStyle,
    this.onCancelButtonStyle,
    this.onContinueButtonStyle,
    this.stepperType = StepperType.vertical,
  });
}
