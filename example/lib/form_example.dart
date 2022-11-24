import 'package:flutter/material.dart';
import "package:boring_form/boring_form.dart";

class FormExample extends StatelessWidget {
  FormExample({super.key});

  final c = BoringFormController();

  @override
  Widget build(BuildContext context) {
    return BoringForm(
      style: BoringFormStyle(
          labelOverField: true,
          inputDecoration: const InputDecoration(border: OutlineInputBorder())),
      fieldController: c,
      fields: [
        BoringSection(
          fieldController: BoringSectionController(),
          title: "SEZIONE",
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
          fieldController: BoringFieldController(),
        ),
      ],
    );
  }
}
