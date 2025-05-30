import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class FormExample0 extends BoringResponsiveFormWidget {
  FormExample0({super.key})
      : super(
          formController: BFormController(
            extensions: (controller, value) {
              final choice = value['choice'] as int?;

              return elements
                  .where((element) => element != choice)
                  .map((e) => BIgnoreField(fieldPath: ['$e'], hideField: true))
                  .toList();
            },
          ),
        );

  @override
  BoringFormStyle styleManipulator(BoringFormStyle style) {
    return super
        .styleManipulator(style)
        .copyWith(fieldsPadding: const EdgeInsets.all(4));
  }

  static List<int> get elements => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  List<Widget> get children => [
        BoringTextField(fieldPath: ['asd']),
        BoringDropdownField(
          fieldPath: ['choice'],
          getItems: (String search) async => elements,
          toBoringChoiceItem: (element) =>
              BChoiceItem(value: element, display: element.toString()),
        ),
        BoringTextField(fieldPath: ['pt']),
        ...elements.map(
          (e) => BResponsiveChild(
            child: BoringArrayFormField<String>(
              fieldPath: ['$e'],
              atLeast: 0,
              atMost: double.maxFinite.toInt(),
              fromValue: (value) => {'value': value},
              toValue: (data) => data['value'],
              elementBuilder: (context, index) =>
                  BoringTextField(fieldPath: ['value']),
            ),
          ),
        ),
        BResponsiveChild(
          child: BMultiElementFormField(
            fieldPath: ["brbr"],
            onAdd: (context) async {},
            onEdit: (context, item) async {},
            itemBuilder: (context, index, item, readOnly, onEdit, onDelete) =>
                Text(item.toString()),
            showAddButton: (context) =>
                Future.delayed(const Duration(seconds: 2), () => true),
          ),
        ),
      ];
}
