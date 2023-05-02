import 'package:flutter/material.dart';
import "package:boring_form/boring_form.dart";
import 'package:boring_form/utils/datetime_extnesions.dart';

class FormExample extends StatelessWidget {
  FormExample({super.key});

  final c = BoringFormController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BoringForm(
          onChanged: (p0) => print("->FORM CHANGED: $p0"),
          style: BoringFormStyle(
              labelOverField: false,
              inputDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero)))),
          formController: c,
          fields: [
            BoringSection(
              onChanged: (p0) => print("->SECTION CHANGED: $p0"),
              displayCondition: (formValue) {
                final a = formValue["slider"] != null
                    ? (formValue["slider"] as double) > 0.2
                    : true;
                return a;
              },
              decoration: BoringFieldDecoration(label: "TITOLO"),
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
              jsonKey: "key",
            ),
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
            BoringTimeField(
              fieldController:
                  BoringFieldController(initialValue: TimeOfDay.now()),
              jsonKey: "time",
            ),
            BoringSlider(
              decoration: BoringFieldDecoration(label: "SLIDER LABEL"),
              jsonKey: "slider",
              divisions: 9,
            ),
            BoringRangeSlider(
              decoration: BoringFieldDecoration(label: "SLIDER LABEL"),
              fieldController:
                  BoringFieldController(initialValue: RangeValues(0.3, 0.8)),
              jsonKey: "rangeslider",
              divisions: 9,
            ),
            BoringPasswordField(
              fieldController: BoringFieldController(
                validationFunction: (value) =>
                    (value != null && value.isNotEmpty)
                        ? (value.length < 6 ? "ALMENO 6 caratteri" : null)
                        : "NULLO NON VA BENE",
              ),
              jsonKey: 'password',
            ),
            BoringNumberField(
              fieldController: BoringFieldController(),
              jsonKey: 'number',
            ),
            BoringDateRangeField(
              fieldController: BoringFieldController(),
              jsonKey: "daterage",
              lastDate: DateTime(2022),
              firstDate: DateTime(2023),
            ),
            BoringEmailField(
              fieldController: BoringFieldController(),
              jsonKey: "email",
              invalidEmailMessage: "Email is not a valid email",
            )
          ],
        ),
        ElevatedButton(onPressed: () => print(c.value), child: Text("VALUE")),
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
                    BoringTextField(
                      boringResponsiveSize: BoringResponsiveSize(md: 6, xl: 3),
                      jsonKey: "name",
                      decoration: BoringFieldDecoration(label: "Nome"),
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
