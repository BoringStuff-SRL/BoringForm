import "package:boring_form/boring_form.dart";
import 'package:boring_form/implementations/boring_connected_field.dart';
import 'package:flutter/material.dart';

class FormExample extends StatelessWidget {
  FormExample({super.key});

  final c = BoringFormController(initialValue: {
    'asd': {
      "key": {"text1": "ale", "text32": "asdsad"},
      "asdsda": {"text1": "ale", "text": "ale"},
    }
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BoringForm(
          haveStepper: true,
          style: BoringFormStyle(
              labelOverField: false,
              inputDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero)))),
          formController: c,
          fields: [
            BoringFormStepper(
              validStepAfterContinue: false,
              jsonKey: 'asd',
              stepperDecoration: BoringStepperDecoration(),
              sections: [
                BoringSection(
                  jsonKey: "key",
                  displayCondition: (formValue) {
                    final a = formValue["slider"] != null
                        ? (formValue["slider"] as double) > 0.2
                        : true;
                    return a;
                  },
                  sectionController: BoringSectionController(),
                  decoration: BoringFieldDecoration(
                      label: "TITOLO", helperText: 'sadsadsadsa'),
                  collapsible: true,
                  fields: [
                    BoringSlider(
                      decoration: BoringFieldDecoration(label: "SLIDER LABEL"),
                      jsonKey: "slider",
                      divisions: 9,
                    ),
                    BoringTextField(
                      // displayCondition: (formValue) =>
                      //     (formValue["slider"] ?? 0 as double) < 0.2,
                      decoration: BoringFieldDecoration(label: "TEXT2"),
                      jsonKey: "text",

                      displayCondition: (value) => false,
                      fieldController: BoringFieldController(
                        validationFunction: (value) =>
                            (value == null || value.isEmpty) ? "ERROR" : null,
                      ),
                    ),
                    BoringTextField(
                      // displayCondition: (formValue) =>
                      //     (formValue["slider"] ?? 0 as double) < 0.2,
                      decoration: BoringFieldDecoration(label: "TEXT1"),
                      jsonKey: "text1",
                      fieldController: BoringFieldController(
                        validationFunction: (value) =>
                            (value == null || value.isEmpty) ? "ERROR" : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        ElevatedButton(
            onPressed: () {
              print("FORM IS ${c.isValid}");
              print("FORM VALUE ${c.value}");
              print("IGNORE ${c.ignoreFields}");
            },
            child: Text("VALUE")),
      ],
    );
  }
}

class FormExample2 extends StatelessWidget {
  final formController = BoringFormController(initialValue: {
    "endDate": ['25']
  });
  final textFieldController = BoringFieldController<String>(
    validationFunction: (value) =>
        (value == null || value.isEmpty) ? "Campo richiesto" : null,
  );

  final ValueNotifier<int> _counter = ValueNotifier(0);

  Widget profileForm(BuildContext context) {
    return SingleChildScrollView(
      child: ValueListenableBuilder(
        valueListenable: _counter,
        builder: (context, value, child) => Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  _counter.value = ++_counter.value;
                },
                child: Text('fai qualcosa')),
            Text(value.toString()),
            BoringForm(
              formController: formController,
              style: BoringFormStyle(
                  //readOnly: true,
                  inputDecoration:
                      InputDecoration(border: OutlineInputBorder()),
                  labelOverField: true,
                  sectionTitleStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              fields: [
                BoringSection(autoValidate: false, jsonKey: 'test', fields: [
                  BoringConnectedField<String?, String?>(
                    childJsonKey: 'connection',
                    pathToConnectedJsonKey: [
                      'test',
                      'test1',
                    ],
                    childBuilder: (context, connectedToValue) {
                      late List<String> items;

                      if (connectedToValue == 'uno') {
                        items = [
                          'taglio',
                          'assemblaggio',
                          'controllo',
                          'imballo',
                        ];
                      } else if (connectedToValue == 'due') {
                        items = [
                          'disegno',
                          'dime',
                          'foratura',
                          'foglio',
                        ];
                      } else {
                        items = ['altro'];
                      }

                      final items1 = items
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList();

                      return BoringDropDownField<String>(
                        jsonKey: 'connection',
                        key: GlobalKey(),
                        fieldController: BoringFieldController(
                          validationFunction: (value) {
                            return (value == null) ? '_invalidField' : null;
                          },
                        ),
                        items: items1,
                      );
                    },
                    formController: formController,
                  ),
                  BoringDropDownField(
                    jsonKey: 'test1',
                    onChanged: (p0) {
                      print('asdasdasd');
                    },
                    fieldController: BoringFieldController(
                      validationFunction: (value) =>
                          value == null ? 'asdasd' : null,
                    ),
                    items: [
                      const DropdownMenuItem(value: 'uno', child: Text('uno')),
                      const DropdownMenuItem(value: 'due', child: Text('due')),
                      const DropdownMenuItem(value: 'tre', child: Text('tre')),
                    ],
                  ),
                ]),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  print("FORM VALUE ${formController.isValid}");
                  print("FORM VALUE ${formController.value}");
                },
                child: Text("GET INFO")),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return profileForm(context);
  }
}
