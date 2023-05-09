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
          //onChanged: (p0) => print("->FORM CHANGED: $p0"),
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
              validStepAfterContinue: true,
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
                  decoration: BoringFieldDecoration(label: "TITOLO", helperText: 'sadsadsadsa'),
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
                      decoration: BoringFieldDecoration(label: "Ciao"),
                      jsonKey: "text1",
                      fieldController: BoringFieldController(
                        validationFunction: (value) =>
                            (value == null || value.isEmpty) ? "ERROR" : null,
                      ),
                    ),
                    BoringTextField(
                      // displayCondition: (formValue) =>
                      //     (formValue["slider"] ?? 0 as double) < 0.2,
                      decoration: BoringFieldDecoration(label: "Ciao"),
                      jsonKey: "text",
                      fieldController: BoringFieldController(
                        validationFunction: (value) =>
                            (value == null || value.isEmpty) ? "ERROR" : null,
                      ),
                    ),
                  ],
                ),
                BoringSection(jsonKey: 'saddsa', fields: [
                  BoringTextField(
                    decoration: BoringFieldDecoration(
                        icon: const Icon(Icons.all_inbox),
                        prefixIcon: const Icon(Icons.inbox_outlined),
                        suffixIcon: const Icon(Icons.inbox_outlined),
                        prefixText: "CIAO",
                        suffixText: "WEWE",
                        counter: ((value) => Text(value ?? ""))),
                    jsonKey: "text",
                  ),
                ]),
                BoringSection(jsonKey: 'sadsf', fields: [
                  BoringDateField(
                    fieldController: BoringFieldController(),
                    jsonKey: 'date',
                    firstlDate: DateTime(1940),
                    lastDate: DateTime(2011),
                  ),
                  BoringPhoneNumberField(
                    invalidPhoneMessage: 'Phone not valid',
                    jsonKey: "emailf",
                  ),
                ])
              ],
            ),
          ],
        ),
        ElevatedButton(
            onPressed: () {
              print("Value: ${c.value}");
              print("Valid: ${c.isValid}");
              print("Init value: ${c.initialValue}");
              print("Changed: ${c.changed}");
            },
            child: Text("VALUE")),
      ],
    );
  }
}

class FormExample2 extends StatelessWidget {
  final formController = BoringFormController(initialValue: {
    "anagraph": {
      "name": "AAA",
      "surname": 'Pippo',
      "birthdate": DateTime(2005, 01, 02)
    }
  });
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
            onChanged: (p0) {
              print("FORM CHANGED");
            },
            style: BoringFormStyle(
                //readOnly: true,
                labelOverField: true,
                sectionTitleStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            fields: [
              BoringSection(
                  decoration: BoringFieldDecoration(label: "ANAGRAFICA"),
                  collapsible: true,
                  collapseOnHeaderTap: true,
                  jsonKey: "anagraph",
                  fields: [
                    BoringNumberField(jsonKey: 'ciaociao'),
                    BoringSideField<String>(
                      widgetDecoration: BoringSideFieldDecoration(
                          backgroundColor: Colors.green),
                      field: BoringTextField(
                        boringResponsiveSize:
                            BoringResponsiveSize(md: 6, xl: 3),
                        jsonKey: "name",
                        fieldController: BoringFieldController(
                          validationFunction: (value) {
                            if (value == null || value.isEmpty) {
                              return "vuoto";
                            }
                          },
                        ),
                        decoration: BoringFieldDecoration(label: "Nome"),
                      ),
                    ),
                    BoringTextField(
                      boringResponsiveSize: BoringResponsiveSize(md: 6, xl: 3),
                      jsonKey: "surname",
                      decoration: BoringFieldDecoration(label: "Cognome"),
                    ),
                    BoringTextField(
                      boringResponsiveSize: BoringResponsiveSize(md: 6, xl: 3),
                      jsonKey: "birthplace",
                      decoration: BoringFieldDecoration(label: "Nato a"),
                    ),
                    BoringDateField(
                      fieldController: BoringFieldController<DateTime?>(
                        validationFunction: (value) =>
                            value == null ? "Campo richiesto" : null,
                      ),
                      lastDate: DateTime(2011),
                      firstlDate: DateTime(1940),
                      boringResponsiveSize: BoringResponsiveSize(md: 6, xl: 3),
                      jsonKey: "birthdate",
                      decoration: BoringFieldDecoration(label: "Nato il"),
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
