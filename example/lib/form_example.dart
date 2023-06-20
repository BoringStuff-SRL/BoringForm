import "package:boring_form/boring_form.dart";
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
  final formController = BoringFormController();
  final textFieldController = BoringFieldController<String>(
    validationFunction: (value) =>
        (value == null || value.isEmpty) ? "Campo richiesto" : null,
  );

  Widget profileForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BoringForm(
            formController: formController,
            style: BoringFormStyle(
                //readOnly: true,
                labelOverField: true,
                sectionTitleStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            fields: [
              BoringSection(
                  autoValidate: false,
                  decoration: BoringFieldDecoration(label: "ANAGRAFICA"),
                  collapsible: true,
                  collapseOnHeaderTap: true,
                  jsonKey: "anagraph",
                  fields: [
                    BoringTextField(
                      boringResponsiveSize: BoringResponsiveSize(md: 6, xl: 3),
                      jsonKey: "name",
                      displayCondition: (value) => false,
                      fieldController: BoringFieldController(
                        validationFunction: (value) {
                          if (value == null || value.isEmpty) {
                            return "nome vuoto";
                          }
                          return null;
                        },
                      ),
                      decoration: BoringFieldDecoration(label: "Nome"),
                    ),
                  ]),
              BoringSection(
                  autoValidate: true,
                  decoration: BoringFieldDecoration(label: "ANAGRAFICAS"),
                  collapsible: true,
                  collapseOnHeaderTap: true,
                  jsonKey: "anagraphs",
                  fields: [
                    BoringTextField(
                      boringResponsiveSize: BoringResponsiveSize(md: 6, xl: 3),
                      jsonKey: "surname",
                      fieldController: BoringFieldController(
                        validationFunction: (value) {
                          if (value == null || value.isEmpty) {
                            return "cognome vuoto";
                          }
                          return null;
                        },
                      ),
                      decoration: BoringFieldDecoration(label: "Cognome"),
                    ),
                    BoringDateField(
                      boringResponsiveSize: BoringResponsiveSize(md: 6, xl: 3),
                      jsonKey: "names",
                      fieldController: BoringFieldController(
                        validationFunction: (value) {
                          if (value == null) {
                            return "nome vuoto";
                          }
                          return null;
                        },
                      ),
                      decoration: BoringFieldDecoration(label: "Nome"),
                      firstlDate: DateTime.now().subtract(Duration(days: 40)),
                      lastDate: DateTime.now(),
                    ),
                    BoringSlider(
                      boringResponsiveSize: BoringResponsiveSize(md: 6, xl: 3),
                      jsonKey: "surnames",
                      fieldController: BoringFieldController(
                        validationFunction: (value) {
                          if (value != 1) {
                            return "cognome vuoto";
                          }
                          return null;
                        },
                      ),
                      decoration: BoringFieldDecoration(label: "Cognome"),
                    ),
                  ]),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                print("FORM IS ${formController.isValid}");
                print("FORM VALUE ${formController.value}");
                print("IGNORE ${formController.ignoreFields}");
              },
              child: Text("GET INFO")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return profileForm(context);
  }
}
