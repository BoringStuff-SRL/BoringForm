import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import "package:boring_form/boring_form.dart";

class TableFormExample extends StatelessWidget {
  TableFormExample({super.key});
  final fc = BoringFormController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BoringForm(
          formController: fc,
          fields: [
            BoringTextField(
              //onChanged: (val) => print(val),
              fieldController: BoringFieldController(
                  initialValue: "Fra",
                  validationFunction: (value) {
                    if (value == null) {
                      return "Campo richiesto";
                    } else if (value.length < 2 || value.length > 24) {
                      return "Nome non valido";
                    }
                    return null;
                  }),
              boringResponsiveSize: BoringResponsiveSize(md: 6, sm: 6),
              jsonKey: "name",
              decoration: BoringFieldDecoration(
                  label: "Nome",
                  hintText: "Inserisci il nome",
                  prefixIcon:
                      Icon(Icons.text_fields_outlined, color: Colors.grey)),
            ).copyWith(),
            BoringTableField(
                jsonKey: 'sections',
                fieldController: BoringFieldController(initialValue: [
                  {"nome": "enzo", "cognome": "de simone"}
                ]),
                decoration: BoringFieldDecoration(
                  label: "Sections",
                ),
                onChanged: (as) {
                  //print('CAMBIATOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO');
                },
                items: [
                  BoringTextField(
                    //onChanged: (val) => print(val),
                    fieldController: BoringFieldController(
                        initialValue: "Fra",
                        validationFunction: (value) {
                          if (value == null) {
                            return "Campo richiesto";
                          } else if (value.length < 2 || value.length > 24) {
                            return "Nome non valido";
                          }
                          return null;
                        }),
                    boringResponsiveSize: BoringResponsiveSize(md: 6, sm: 6),
                    jsonKey: "name",
                    decoration: BoringFieldDecoration(
                        label: "Nome",
                        hintText: "Inserisci il nome",
                        prefixIcon: Icon(Icons.text_fields_outlined,
                            color: Colors.grey)),
                  ),
                  // BoringTextField(
                  //   fieldController: BoringFieldController<String>(
                  //       validationFunction: (value) {
                  //     if (value == null) {
                  //       return "Campo richiesto";
                  //     } else if (value.length < 2 || value.length > 24) {
                  //       return "Cognome non valido";
                  //     }
                  //     return null;
                  //   }),
                  //   boringResponsiveSize: BoringResponsiveSize(md: 6, sm: 6),
                  //   jsonKey: "cognome",
                  //   decoration: BoringFieldDecoration(
                  //       label: "Cognome",
                  //       hintText: "Inserisci il cognome",
                  //       prefixIcon: Icon(Icons.text_fields_outlined,
                  //           color: Colors.grey)),
                  // ),
                ]),
          ],
        ),
        ElevatedButton(
            onPressed: () {
              print(fc.value);
            },
            child: Text("GET"))
      ],
    );
  }
}
