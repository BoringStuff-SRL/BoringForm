import '../../field/boring_field.dart';
import '../../field/boring_field_controller.dart';

class BoringStepperController
    extends BoringFieldController<Map<String, dynamic>> {
  BoringStepperController({super.initialValue});

  final List<Map<String, BoringFieldController>> controllers = [];

  @override
  bool get isValid => errorMessage == null && _allSectionControllersValid();

  @override
  Map<String, dynamic>? get value {
    final Map<String, dynamic> newValue = {};

    for (var e in controllers) {
      e.forEach((k, v) {
        newValue[k] = v.value;
      });
    }

    return newValue;
  }

  @override
  void setValueSilently(Map<String, dynamic>? newValue) {
    controllers.clear();

    for (int i = 0; i < newValue!.length; i++) {
      Map<String, dynamic> row = newValue[i];
      controllers.add(Map.from(row));
    }
  }

  void addControllers(List<BoringField> fields) {
    controllers.add(
        {for (var field in fields) (field).jsonKey: (field).fieldController});
  }

  bool _allSectionControllersValid() {
    bool isValid = true;

    for (var e in controllers) {
      if ((Map.from(e).values.any((element) => !element.isValid))) {
        isValid = false;
        break;
      }
    }

    return isValid;
  }
}
