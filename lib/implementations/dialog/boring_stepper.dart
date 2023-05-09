import 'package:boring_form/boring_form.dart';
import 'package:flutter/material.dart';

class BoringFormStepper extends BoringField {
  BoringFormStepper({
    BoringStepperController? boringStepperController,
    super.key,
    required super.jsonKey,
    required this.sections,
    this.stepperDecoration,
    this.validStepAfterContinue = false,
  }) : super(
            fieldController:
                boringStepperController ?? BoringStepperController());

  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  final List<BoringSection> sections;
  final BoringStepperDecoration? stepperDecoration;
  final List<BoringSection> _finalSections = [];
  final bool validStepAfterContinue;

  @override
  bool setInitialValue(initialValue) {
    final v = super.setInitialValue(initialValue);

    if (v) {
      if (sections.length != _finalSections.length) {
        for (var e in sections) {
          _finalSections.add(e.copyWith(
              sectionController: BoringSectionController(
                  initialValue:
                      (initialValue as Map<String, dynamic>?)?[e.jsonKey])));
        }
      } else {
        for (int i = 0; i < _finalSections.length; i++) {
          _finalSections[i] = _finalSections[i].copyWith(
              sectionController: BoringSectionController(
                  initialValue: (initialValue
                      as Map<String, dynamic>?)?[_finalSections[i].jsonKey]));
        }
      }
    }

    (fieldController as BoringStepperController).addControllers(_finalSections);
    return false;
  }

  @override
  Widget builder(context, controller, child) {
    final style = getStyle(context);

    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
            valueListenable: _currentIndex,
            builder: (context, value, child) {
              return Stepper(
                currentStep: value,
                type: StepperType.vertical,
                onStepTapped: (index) => _onStepTapped(index, controller),
                onStepCancel: _onStepCancel,
                onStepContinue: () => _onStepContinue(value, controller),
                controlsBuilder: (context, details) =>
                    _stepperButtonControl(details),
                steps: List.generate(
                    _finalSections.length,
                    (i) => Step(
                        title: Text(_finalSections[i].decoration?.label ?? ''),
                        subtitle: _finalSections[i].decoration?.helperText !=
                                null
                            ? Text(_finalSections[i].decoration!.helperText!)
                            : null,
                        content: _finalSections[i])),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _stepperButtonControl(ControlsDetails details) {
    return Row(
      children: <Widget>[
        stepperDecoration?.onCancelButton?.call(details) ??
            TextButton(
              onPressed: details.onStepCancel,
              child: const Text('CANCEL'),
            ),
        const SizedBox(width: 10),
        stepperDecoration?.onContinueButton?.call(details) ??
            TextButton(
              onPressed: details.onStepContinue,
              child: const Text('CONTINUE'),
            ),
      ],
    );
  }

  void _onStepContinue(int currentIndex, BoringFieldController controller) {
    if (currentIndex < sections.length - 1) {
      if (!validStepAfterContinue) {
        _currentIndex.value++;
      } else if (sections[currentIndex].controller.isValid) {
        _currentIndex.value++;
      }
    }
  }

  void _onStepCancel() {
    if (_currentIndex.value > 0) {
      _currentIndex.value--;
    }
  }

  void _onStepTapped(int index, BoringFieldController controller) {
    if (!validStepAfterContinue) {
      _currentIndex.value = index;
    } else if (index < _currentIndex.value) {
      _currentIndex.value = index;
    } else if (sections[_currentIndex.value].controller.isValid) {
      _currentIndex.value = index;
    }
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
