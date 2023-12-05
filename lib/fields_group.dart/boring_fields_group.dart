import 'package:boring_form/boring_form.dart';
import 'package:boring_form/field/field_change_notification.dart';
import 'package:boring_form/field/filtered_fields_provider.dart';
import 'package:flutter/material.dart';

abstract class BoringFieldsGroupController
    extends BoringFieldController<Map<String, dynamic>> {
  BoringFieldsGroupController({super.initialValue, super.validationFunction});

  Map<String, BoringFieldController> subControllers = {};
  Set<String> ignoreFields = {};

  @override
  Map<String, dynamic>? get value {
    return subControllers.map((key, value) => MapEntry(key, value.value))
      ..removeWhere((key, value) => ignoreFields.contains(key));
  }

  @override
  set value(Map<String, dynamic>? newValue) {
    super.value = newValue;
    for (var key in subControllers.keys) {
      if (newValue?.containsKey(key) ?? false) {
        subControllers[key]?.value = newValue![key];
      } else {
        subControllers[key]?.value = null;
      }
    }
  }

  bool _allSubControllersValid() {
    bool valid = true;

    for (var element in ((Map.from(subControllers))
          ..removeWhere((key, value) => ignoreFields.contains(key)))
        .values) {
      if (!element.isValid) {
        valid = false;
      }
    }

    return valid;
  }

  @override
  bool get isValid => errorMessage == null && _allSubControllersValid();

  @override
  void reset() {
    super.reset();
    for (var controller in subControllers.values) {
      controller.reset();
    }
    notifyListeners();
  }
}

abstract class BoringFieldsGroup<T extends BoringFieldsGroupController>
    extends BoringField<Map<String, dynamic>> {
  final List<BoringField> fields;
  final T controller;

  final bool autoValidate;

  BoringFieldsGroup(
      {super.key,
      required this.controller,
      required super.jsonKey,
      this.autoValidate = false,
      super.onChanged,
      //TODO (was in SECTION) this.collapsible = false,
      //TODO (was in SECTION) this.collapseOnHeaderTap,
      super.decoration,
      super.displayCondition,
      required this.fields})
      : assert(checkJsonKey(fields, autoValidate: autoValidate),
            "Confict error: found duplicate jsonKeys in section with jsonKey '$jsonKey'"),
        super(fieldController: controller) {
    _addFieldsSubcontrollers();
  }

  @override
  bool ignoreInitialValue(Map<String, dynamic>? value) =>
      value != null && value.isNotEmpty;

  @override
  bool setInitialValue(Map<String, dynamic>? initialValue) {
    final v = super.setInitialValue(initialValue);
    if (v) {
      _setSubFieldsInitialValues();
    }
    return v;
  }

  static bool checkJsonKey(List<BoringField> fields,
      {bool autoValidate = false}) {
    List<String> keys = [];
    for (var field in fields) {
      if (autoValidate) {
        field.fieldController.autoValidate = autoValidate;
      }

      if (keys.contains(field.jsonKey)) {
        return false;
      }
      keys.add(field.jsonKey);
    }
    return true;
  }

  final blockNotificationPropagation = false;
  final fieldsListProvider = FieldsListProvider();

  void formChanged() {
    updateFilteredFieldsList();
  }

  @protected
  void onAnyChanged() {
    onChanged?.call(controller.value);
  }

  @protected
  void updateFilteredFieldsList() {
    BoringFormController formController;
    if (controller is BoringFormController) {
      formController = controller as BoringFormController;
    } else if (contextHolder.value != null) {
      formController = Provider.of<BoringFormController>(contextHolder.value!,
          listen: false);
    } else {
      return;
    }

    final excluded = fieldsListProvider.notifyIfDifferentFields(
        fields, formController.value ?? {});

    if (true /*TODO add [exludeInvalidFields = true] attribute (ex: maybe you want to include invalid fields and so this condition should be false)*/) {
      controller.ignoreFields = excluded;
    }
  }

  void _setSubFieldsInitialValues() {
    for (var field in fields) {
      if (controller.initialValue?[field.jsonKey] != null) {
        field.setInitialValue(controller.initialValue?[field.jsonKey]);
      }
    }
  }

  void _addFieldsSubcontrollers() {
    for (var field in fields) {
      controller.subControllers[field.jsonKey] = field.fieldController;
    }
    //_setSubFieldsInitialValues();
  }

  //TODO check this
  // @override
  // void onValueChanged(Map<String, dynamic>? newValue) {
  //   for (var field in fields) {
  //     field.fieldController.value =
  //         (newValue != null && newValue.containsKey(field.jsonKey))
  //             ? newValue[field.jsonKey]
  //             : null;
  //   }
  // }

  Widget _content() => LayoutBuilder(
        builder: (context, constraints) =>
            NotificationListener<FieldChangeNotification>(
          onNotification: (notification) {
            onAnyChanged();
            return blockNotificationPropagation;
          },
          child: ChangeNotifierProvider(
              create: (context) => fieldsListProvider,
              child: Consumer<FieldsListProvider>(
                  builder: (context, value, _) => Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: List.generate(fields.length, (index) {
                          return Offstage(
                            offstage: !fieldsListProvider
                                .isFieldOnStage(fields[index]),
                            child: FractionallySizedBox(
                              widthFactor: fields[index]
                                      .boringResponsiveSize
                                      .breakpointValue(constraints.maxWidth) /
                                  12,
                              child: fields[
                                  index], //should we wrap this inside padding? Each field already has the padding
                            ),
                          );
                        }),
                      ))),
        ),
      );

  @override
  Widget builder(context, controller, child) {
    formChanged();
    return buildWidget(context, this.controller, _content());
  }

  Widget buildWidget(BuildContext context,
      BoringFieldsGroupController controller, Widget content);
}
