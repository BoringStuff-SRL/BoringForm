import 'package:flutter/material.dart';
import "package:boring_form/boring_form.dart";

class FormExample extends StatelessWidget {
  FormExample({super.key});

  final c = BoringFormController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BoringForm(
          style: BoringFormStyle(
              labelOverField: false,
              inputDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero)))),
          fieldController: c,
          fields: [
            BoringSection(
              decoration: BoringFieldDecoration(label: "TITOLO"),
              collapsible: true,
              fields: [
                BoringTextField(
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
              fieldController:
                  BoringFieldController(initialValue: DateTime.now()),
              jsonKey: 'date',
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
            ),
            BoringEmailField(
              fieldController: BoringFieldController(),
              jsonKey: "email",
              invalidEmailMessage: "Email is not a valid email",
            )
          ],
        ),
        ElevatedButton(onPressed: () => print(c.value), child: Text("VALUE"))
      ],
    );
  }
}
