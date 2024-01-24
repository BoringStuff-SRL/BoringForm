import 'package:boring_form/implementations/stepper/boring_stepper_style.dart';
import 'package:flutter/material.dart';

import 'boring_step.dart';
import 'boring_stepper_controller.dart';

class BoringStepper extends StatelessWidget {
  BoringStepper(
      {super.key,
      BoringStepperController? stepperController,
      this.stepperStyle = const BoringStepperStyle(),
      required this.steps})
      : stepperController = stepperController ?? BoringStepperController();

  final BoringStepperController stepperController;
  final List<BoringStep> steps;
  final BoringStepperStyle stepperStyle;

  bool get canContinue => stepperController.activeStepIndex < steps.length - 1;

  bool get canGoBack => stepperController.activeStepIndex > 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: stepperController,
      builder: (context, child) => Stepper(
        type: stepperStyle.stepperType,
        currentStep: stepperController.activeStepIndex,
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
          if (canContinue) stepperController.nextStep();
        },
        onStepCancel: () {
          stepperController.previousStep();
        },
        onStepTapped: (value) {
          stepperController.changeStepIndex(value);
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
    );
  }
}
