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
        BResponsiveChild(
          child: BoringArrayFormField<DateTime>(
            fieldPath: ['array'],
            atLeast: 0,
            atMost: 10,
            fromValue: (value) => {
              'value': value,
            },
            toValue: (data) {
              return DateTime.tryParse(data['value'] ?? '');
            },
            elementBuilder: (context) {
              return BoringDateField(
                fieldPath: ['value'],
                required: true,
                firstDate: DateTime(1900),
                lastDate: DateTime(2030),
              );
            },
          ),
        ),
        BResponsiveChild(
          child: ListenableBuilder(
            listenable: formController,
            builder: (context, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('IS VALID?: ${formController.isValid}'),
                  ...(formController.value['array'] as List?)?.map(
                        (e) => Text("${e}"),
                      ) ??
                      [],
                ],
              );
            },
          ),
        ),
        BoringDateField(
          fieldPath: ['value'],
          required: true,
          firstDate: DateTime(1900),
          lastDate: DateTime(2030),
        ),
        BResponsiveChild(
          child: BButton(
            text: 'IS VALID?',
            onPressed: () {
              print(formController.isValid);
            },
          ),
        ),
        BResponsiveChild(
          child: BButton(
            text: 'GET VALUE?',
            onPressed: () {
              print(formController.getFormValue());
            },
          ),
        ),
      ];
}
