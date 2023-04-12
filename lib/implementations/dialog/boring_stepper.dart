import 'dart:async';

import 'package:boring_form/boring_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

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

class BoringStepper extends StatelessWidget {
  const BoringStepper({
    super.key,
    required this.jsonKey,
    this.formStyle,
    this.decoration = const BoringStepperDecoration(),
    required this.onConfirmButtonPress,
    required this.formController,
    required this.sections,
  });

  final String jsonKey;
  final BoringFormStyle? formStyle;
  final BoringFormController formController;
  final List<BoringSection> sections;
  final BoringStepperDecoration decoration;
  final FutureOr<void> Function(BuildContext context) onConfirmButtonPress;

  @override
  Widget build(BuildContext context) {
    return BoringForm(
      formController: formController,
      style: formStyle,
      fields: [
        _BoringFormStepperWidget(
          jsonKey: jsonKey,
          sections: sections,
          formController: formController,
          onConfirmButtonPress: onConfirmButtonPress,
          dialogDecoration: decoration,
        )
      ],
    );
  }

  static void showStepperDialog(
    BuildContext context, {
    required String jsonKey,
    BoringFormStyle? formStyle,
    BoringStepperDecoration decoration = const BoringStepperDecoration(),
    required BoringFormController formController,
    required List<BoringSection> sections,
    required FutureOr<void> Function(BuildContext context) onConfirmButtonPress,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: decoration.dialogShapeBorder,
          child: SingleChildScrollView(
            child: Container(
              width: decoration.dialogWidth,
              padding: decoration.contentPadding,
              child: BoringStepper(
                formController: formController,
                jsonKey: jsonKey,
                sections: sections,
                formStyle: formStyle,
                onConfirmButtonPress: onConfirmButtonPress,
                decoration: decoration,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BoringFormStepperWidget extends BoringField {
  _BoringFormStepperWidget(
      {required super.jsonKey,
      required this.sections,
      required this.formController,
      required this.onConfirmButtonPress,
      required this.dialogDecoration,
      super.fieldController,
      this.style}) {
    style ??= BoringFormStyle();
  }

  BoringFormStyle? style;
  ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  final List<BoringSection> sections;
  final BoringStepperDecoration dialogDecoration;
  final BoringFormController formController;
  final FutureOr<void> Function(BuildContext context) onConfirmButtonPress;

  List<Step> get _steps => sections
      .map(
        (e) => Step(
          title: Text(e.decoration?.label ?? ''),
          content: e.copyWith(
            decoration: BoringFieldDecoration(),
          ),
        ),
      )
      .toList();

  void _onStepContinue(int currentIndex, BoringFieldController controller) {
    if (currentIndex < sections.length - 1) {
      _currentIndex.value++;
    }
  }

  void _onStepCancel() {
    if (_currentIndex.value > 0) {
      _currentIndex.value--;
    }
  }

  void _onStepTapped(int index) {
    _currentIndex.value = index;
  }

  @override
  Widget builder(
      BuildContext context, BoringFieldController controller, Widget? child) {
    return BoringField.boringFieldBuilder(
      style!,
      '',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
            valueListenable: _currentIndex,
            builder: (context, currentIndex, child) {
              return Stepper(
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  return Row(
                    children: <Widget>[
                      dialogDecoration.onContinueButton?.call(details) ??
                          TextButton(
                            onPressed: details.onStepContinue,
                            child: const Text('CONTINUE'),
                          ),
                      dialogDecoration.onCancelButton?.call(details) ??
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('CANCEL'),
                          ),
                    ],
                  );
                },
                currentStep: currentIndex,
                type: StepperType.vertical,
                onStepContinue: () {
                  _onStepContinue(currentIndex, controller);
                },
                onStepTapped: _onStepTapped,
                onStepCancel: _onStepCancel,
                steps: _steps,
              );
            },
          ),
          Align(
            alignment: dialogDecoration.buttonAlignment,
            child: ElevatedButton(
              style: dialogDecoration.buttonStyle,
              onPressed: () {
                controller.value = {};
                for (BoringSection section in sections) {
                  (controller.value as Map).addEntries(
                      {section.jsonKey: section.controller.value!}.entries);
                }
                controller.sendNotification();

                onConfirmButtonPress.call(context);
              },
              child: dialogDecoration.actionButtonText ?? const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  BoringField copyWith(
      {BoringFieldController? fieldController,
      void Function(dynamic p1)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic> p1)? displayCondition}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}
