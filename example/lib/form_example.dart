import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class FormExample0 extends BoringResponsiveFormWidget {
  FormExample0({super.key})
      : super(
          formController: BFormController(
            extensions: (controller, value) {
              final choice = value['choice'] as int?;

              final ext = <BFormExtension>[];

              final excludeOne =
                  BIgnoreField(fieldPath: ['one'], hideField: true);
              final excludeTwo =
                  BIgnoreField(fieldPath: ['two'], hideField: true);
              final excludeThree =
                  BIgnoreField(fieldPath: ['three'], hideField: true);

              switch (choice) {
                case 1:
                  ext.add(excludeTwo);
                  ext.add(excludeThree);
                  break;
                case 2:
                  ext.add(excludeOne);
                  ext.add(excludeThree);
                  break;
                case 3:
                  ext.add(excludeOne);
                  ext.add(excludeTwo);
                  break;
                default:
                  ext.add(excludeOne);
                  ext.add(excludeTwo);
                  ext.add(excludeThree);
              }

              return ext;
            },
          ),
        );

  @override
  BoringFormStyle styleManipulator(BoringFormStyle style) {
    return super
        .styleManipulator(style)
        .copyWith(fieldsPadding: const EdgeInsets.all(4));
  }

  @override
  List<Widget> get children => [
        BoringDropdownField(
          fieldPath: ['choice'],
          getItems: (search) async {
            await Future.delayed(const Duration(seconds: 2));
            return [1, 2, 3];
          },
          decoration: (formController) =>
              BoringFieldDecoration(label: 'Fai la tua scelta'),
          toBoringChoiceItem: (element) =>
              BChoiceItem(value: element, display: '$element'),
        ),
        BoringTextField(
          fieldPath: ['one'],
          decoration: (formController) =>
              BoringFieldDecoration(label: 'Hai scelto 1!'),
        ),
        BoringTextField(
          fieldPath: ['two'],
          decoration: (formController) =>
              BoringFieldDecoration(label: 'Hai scelto 2!'),
        ),
        BoringTextField(
          fieldPath: ['three'],
          decoration: (formController) =>
              BoringFieldDecoration(label: 'Hai scelto 3!'),
        ),
      ];
}
