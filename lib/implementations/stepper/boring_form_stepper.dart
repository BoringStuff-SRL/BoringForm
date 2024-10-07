import 'package:boring_form/boring_form.dart';
import 'package:flutter/cupertino.dart';

class BoringFormWithTitle {
  final String title;
  final BoringFormWidget form;

  BoringFormWithTitle({required this.title, required this.form});
}

class BoringFormStepper extends StatelessWidget {
  BoringFormStepper(
      {required this.forms,
      this.mustBeValidToContinue = true,
      this.hideControls = false,
      BoringStepperController? stepperController,
      this.stepperStyle = const BoringStepperStyle()})
      : stepperController = stepperController ?? BoringStepperController();

  final List<BoringFormWithTitle> forms;
  final bool mustBeValidToContinue;
  final BoringStepperStyle stepperStyle;
  final BoringStepperController stepperController;
  final bool hideControls;

  bool isFormValid(int index) => forms[index].form.formController.isValid;

  @override
  Widget build(BuildContext context) {
    return BoringStepper(
      hideControls: hideControls,
      stepperController: stepperController,
      stepperStyle: stepperStyle,
      onStepContinue: mustBeValidToContinue
          ? (newIndex) {
              if (isFormValid(newIndex - 1)) {
                stepperController.nextStep();
              }
            }
          : null,
      onStepTapped: mustBeValidToContinue
          ? (newIndex) {
              if ((newIndex > stepperController.activeStepIndex &&
                      isFormValid(stepperController.activeStepIndex)) ||
                  (newIndex < stepperController.activeStepIndex)) {
                stepperController.changeStepIndex(newIndex);
              }
            }
          : null,
      steps: forms
          .map(
            (e) => BoringStep(
              child: e.form,
              title: e.title,
            ),
          )
          .toList(),
    );
  }
}
