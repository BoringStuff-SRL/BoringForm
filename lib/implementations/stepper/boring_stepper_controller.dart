import 'package:flutter/cupertino.dart';

class BoringStepperController extends ChangeNotifier {
  int activeStepIndex;

  BoringStepperController({this.activeStepIndex = 0});

  bool isStepActive(int index) => activeStepIndex == index;

  void nextStep() {
    activeStepIndex++;
    notifyListeners();
  }

  void previousStep() {
    if (activeStepIndex > 0) {
      activeStepIndex--;
      notifyListeners();
    }
  }

  void changeStepIndex(int index) {
    if (activeStepIndex != index) {
      activeStepIndex = index;
      notifyListeners();
    }
  }
}
