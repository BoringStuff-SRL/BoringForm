import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringArrayFormField<T extends String> extends BFormField<List<T?>> {
  BoringArrayFormField({
    super.key,
    required super.fieldPath,
    required this.atLeast,
    required this.atMost,
    required this.fromValue,
    required this.toValue,
    required this.elementBuilder,
    this.addElementText = 'Aggiungi elemento',
    super.observedFields,
    super.onChanged,
    super.readOnly,
    super.responsiveSize,
  })  : _controllers = [],
        super(required: false);

  final String addElementText;
  final int atLeast;
  final int atMost;
  final T? Function(Map<String, dynamic> data) toValue;
  final Map<String, dynamic> Function(T? value) fromValue;
  final Widget Function(BuildContext context) elementBuilder;
  final List<BFormController> _controllers;

  Widget formBuilder(BuildContext context, int i, {required bool readOnly}) {
    return BoringForm(
      formController: _controllers[i],
      style: (context) =>
          BoringTheme.of(context).boringFormStyle.copyWith(readOnly: readOnly),
      child: elementBuilder(context),
    );
  }

  void syncValues(BFormController formController) {
    final values = _controllers.map((e) => toValue(e.value)).toList();
    formController.setFieldValue(fieldPath, values, notify: true);
  }

  void populateControllers(
      BFormController formController, List<T?>? fieldValue) {
    final valueLen = fieldValue?.length ?? 0;

    for (var i = _controllers.length; i < valueLen; i++) {
      final fc = BFormController(
        initialValue: fromValue(fieldValue?[i]),
      );
      fc.addListener(
        () {
          syncValues(formController);
        },
      );

      _controllers.add(fc);
    }
  }

  @override
  ValidationFunction<List<T?>>? get validationFunction =>
      ((formController, value) {
        final valueLen = value?.length ?? 0;
        if (valueLen < atLeast) {
          return 'Devi inserire almeno $atLeast attributi';
        }
        if (valueLen > atMost) {
          return 'Devi inserire al massimo $atMost attributi';
        }

        final allFieldsAreValid =
            _controllers.every((element) => element.isValid);

        if (!allFieldsAreValid) {
          return 'Tutti i campi devono essere validi';
        }
        return super.validationFunction?.call(formController, value);
      });

  @override
  Widget fieldBuilder(
    BuildContext context,
    BoringFormStyle formStyle,
    BFormController formController,
    List<T?>? fieldValue,
    FieldValidation fieldValidation,
    void computedValue,
  ) {
    final valueLen = fieldValue?.length ?? 0;

    populateControllers(formController, fieldValue);

    final canAddElements = valueLen < atMost && !fieldValidation.isReadOnly;
    final canRemoveElements = valueLen > atLeast && !fieldValidation.isReadOnly;

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fieldValidation.error != null)
          BText(
            fieldValidation.error!,
            color: BColor.error,
          ),
        BButton(
          onPressed: canAddElements
              ? () {
                  // aggiungo null al formController esterno
                  formController.setFieldValue(
                    fieldPath,
                    [...fieldValue ?? <T?>[], null],
                  );
                }
              : null,
          level: canAddElements ? BColor.primary : BColor.disabled,
          text: addElementText,
        ),
        ...List.generate(
          valueLen,
          (index) {
            return Row(
              children: [
                Expanded(
                  child: formBuilder(context, index,
                      readOnly: fieldValidation.isReadOnly),
                ),
                if (canRemoveElements)
                  BButton(
                    onPressed: () {
                      _controllers.removeAt(index);
                      formController.setFieldValue(
                        fieldPath,
                        fieldValue!..removeAt(index),
                      );
                    },
                    leadingIcon: BIcon(BIcons.trash),
                  )
              ],
            );
          },
        ),
      ],
    );
  }
}
