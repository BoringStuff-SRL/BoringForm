import '../../field/boring_field.dart';
import '../../field/boring_field_controller.dart';

class BoringTableFieldController
    extends BoringFieldController<List<Map<String, dynamic>>> {
  BoringTableFieldController({super.initialValue});

  final List<Map<String, BoringFieldController>> controllers = [];

  @override
  List<Map<String, dynamic>>? get value {
    return controllers
        .map((e) => e.map((key, value) => MapEntry(key, value.value)))
        .toList();
  }

  @override
  void setValueSilently(List<Map<String, dynamic>>? newValue) {
    controllers.clear();

    for (int i = 0; i < newValue!.length; i++) {
      Map<String, dynamic> row = newValue[i];
      controllers.add(Map.from(row));
    }
  }

  @override
  bool get isValid => errorMessage == null && _allRowControllersValid();

  void addControllers(List<BoringField> fields) {
    controllers.add(
        {for (var field in fields) (field).jsonKey: (field).fieldController});
  }

  void removeController(int index) {
    controllers.removeAt(index);
  }

  bool _allRowControllersValid() {
    bool isValid = true;

    for (var row in controllers) {
      if ((Map.from(row).values.any((element) => !element.isValid))) {
        isValid = false;
        break;
      }
    }

    return isValid;
  }
}
