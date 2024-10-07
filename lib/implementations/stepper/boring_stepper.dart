import 'dart:math';

import 'package:boring_form/implementations/stepper/boring_stepper_style.dart';
import 'package:flutter/material.dart';

import 'boring_step.dart';
import 'boring_stepper_controller.dart';

class BoringStepper extends StatelessWidget {
  BoringStepper(
      {super.key,
      BoringStepperController? stepperController,
      this.stepperStyle = const BoringStepperStyle(),
      this.onStepCancel,
      this.onStepContinue,
      this.onStepTapped,
      required this.steps})
      : stepperController = stepperController ?? BoringStepperController();

  final BoringStepperController stepperController;
  final List<BoringStep> steps;
  final BoringStepperStyle stepperStyle;
  final Function(int newIndex)? onStepContinue;
  final Function(int newIndex)? onStepCancel;
  final Function(int newIndex)? onStepTapped;

  bool get canContinue => stepperController.activeStepIndex < steps.length - 1;

  bool get canGoBack => stepperController.activeStepIndex > 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(canvasColor: Colors.transparent),
      child: ListenableBuilder(
        listenable: stepperController,
        builder: (context, child) => Stepper(
          type: stepperStyle.stepperType,
          currentStep: stepperController.activeStepIndex,
          elevation: 0.0,
          controlsBuilder: (context, details) {
            return Row(
              children: [
                if (canGoBack)
                  FilledButton.tonal(
                    onPressed: () {
                      details.onStepCancel!.call();
                    },
                    style: stepperStyle.onCancelButtonStyle,
                    child: Text(stepperStyle.onCancelText),
                  ),
                const SizedBox(width: 5),
                if (canContinue)
                  FilledButton(
                    onPressed: () {
                      details.onStepContinue!.call();
                    },
                    style: stepperStyle.onContinueButtonStyle,
                    child: Text(stepperStyle.onContinueText),
                  ),
              ],
            );
          },
          onStepContinue: () {
            if (canContinue) {
              if (onStepContinue != null) {
                onStepContinue?.call(stepperController.activeStepIndex + 1);
              } else {
                stepperController.nextStep();
              }

              // questa cosa mi esegue entrambe le chiamate
              // onStepContinue?.call(stepperController.activeStepIndex + 1) ??
              //     stepperController.nextStep();
            }
          },
          onStepCancel: () {
            if (onStepCancel != null) {
              onStepCancel?.call(max(0, stepperController.activeStepIndex - 1));
            } else {
              stepperController.previousStep();
            }
          },
          onStepTapped: (value) {
            if (onStepTapped != null) {
              onStepTapped?.call(value);
            } else {
              stepperController.changeStepIndex(value);
            }
          },
          steps: steps.map(
            (e) {
              final isActive = stepperController.isStepActive(steps.indexOf(e));

              return Step(
                title: Text(e.title, style: stepperStyle.titleTextStyle),
                content: e.child,
                isActive: isActive,
                state: isActive ? StepState.editing : StepState.indexed,
                subtitle: e.subTitle == null
                    ? null
                    : Text(
                        e.subTitle!,
                        style: stepperStyle.subTitleTextStyle,
                      ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
