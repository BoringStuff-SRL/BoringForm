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
    "anagraph": {"name": "EWE", "birthdate": DateTime(2005, 01, 02)}
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
                    BoringRadioGroupField(
                      jsonKey: "CIAO",
                      fieldController: BoringFieldController(initialValue: 2),
                      decoration: BoringFieldDecoration(label: "RADIO"),
                      items: const [
                        BoringChoiceItem(display: "!", value: 1),
                        BoringChoiceItem(display: "2", value: 2),
                        BoringChoiceItem(display: "3", value: 3),
                      ],
                    ),
                    BoringTextField(
                      fieldController:
                          BoringFieldController(initialValue: null),
                      boringResponsiveSize: BoringResponsiveSize(md: 6, xl: 3),
                      jsonKey: "name",
                      decoration: BoringFieldDecoration(label: "Nome"),
                    ),
                    BoringTextField(
                      fieldController:
                          BoringFieldController(initialValue: "CIAONE"),
                      boringResponsiveSize: BoringResponsiveSize(md: 6, xl: 3),
                      jsonKey: "surname",
                      decoration: BoringFieldDecoration(label: "Cognome"),
                    ),
                    BoringTextField(
                      fieldController: textFieldController.copyWith(),
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
              BoringSection(
                  displayCondition: (formValue) {
                    //print(formValue["anagraph"]?["birthdate"] != null);
                    //return (formValue["anagraph"]?["birthdate"] != null);
                    final a = (formValue["anagraph"]?["birthdate"] != null)
                        ? (formValue["anagraph"]?["birthdate"] as DateTime)
                                .year >=
                            2005
                        : true;
                    print("DISPLAY COND = $a");
                    return a;
                  },
                  decoration: BoringFieldDecoration(label: "GENITORI"),
                  jsonKey: "parents",
                  collapsible: true,
                  collapseOnHeaderTap: true,
                  fields: [
                    BoringTextField(
                      fieldController: textFieldController.copyWith(),
                      jsonKey: "p_name_1",
                      decoration: BoringFieldDecoration(label: "Nome"),
                      boringResponsiveSize: BoringResponsiveSize(md: 4),
                    ),
                    BoringTextField(
                      fieldController: textFieldController.copyWith(),
                      decoration: BoringFieldDecoration(label: "Cognome"),
                      jsonKey: "p_surname_1",
                      boringResponsiveSize: BoringResponsiveSize(md: 4),
                    ),
                    BoringTextField(
                      fieldController: textFieldController.copyWith(),
                      decoration: BoringFieldDecoration(label: "Telefono"),
                      boringResponsiveSize: BoringResponsiveSize(md: 4),
                      jsonKey: "p_phone_1",
                    ),
                    BoringTextField(
                      jsonKey: "p_name_2",
                      decoration: BoringFieldDecoration(label: "Nome"),
                      boringResponsiveSize: BoringResponsiveSize(md: 4),
                    ),
                    BoringTextField(
                      decoration: BoringFieldDecoration(label: "Cognome"),
                      jsonKey: "p_surname_2",
                      boringResponsiveSize: BoringResponsiveSize(md: 4),
                    ),
                    BoringTextField(
                      decoration: BoringFieldDecoration(label: "Telefono"),
                      boringResponsiveSize: BoringResponsiveSize(md: 4),
                      jsonKey: "p_phone_2",
                    )
                  ]),
            ],
            formController: formController,
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
