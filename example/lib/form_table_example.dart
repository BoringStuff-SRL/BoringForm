import 'package:boring_form/implementations/choice/boring_multichoice_dropdown_field.dart';
import 'package:boring_form/implementations/table/boring_table_form_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import "package:boring_form/boring_form.dart";
import 'package:boring_table/boring_table.dart';

class User {
  final String username;

  User(this.username);

  @override
  operator ==(Object other) => (other as User).username == username;

  @override
  int get hashCode => super.hashCode;
}

class TableFormExample extends StatelessWidget {
  TableFormExample({super.key});

  final fc = BoringFormController(initialValue: {
    'test': {
      'surname': 'ASd',
    },
    "table": [
      {'drop': "PIPPO", "name": 'SIUUU'}
    ]
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BoringForm(
          formController: fc,
          includeNotDisplayedInValidation: false,
          style: BoringFormStyle(
              readOnly: false,
              labelOverField: false,
              inputDecoration:
                  const InputDecoration(border: OutlineInputBorder())),
          fields: [
            BoringSection(
              jsonKey: 'test',
              fields: [
                BoringDropDownField(
                  jsonKey: 'dropdown',
                  items: [
                    DropdownMenuItem(
                      value: 'asd',
                      child: Text('asd'),
                    )
                  ],
                ),
                BoringTextField(
                  //onChanged: (val) => print(val),
                  fieldController:
                      BoringFieldController(validationFunction: (value) {
                    if (value == null) {
                      return "Campo richiesto";
                    } else if (value.length < 2 || value.length > 24) {
                      return "Nome non valido";
                    }
                    return null;
                  }),
                  boringResponsiveSize: BoringResponsiveSize(md: 6, sm: 6),
                  jsonKey: "surname",
                  decoration: BoringFieldDecoration(
                      label: "Nome",
                      hintText: "Inserisci il nome",
                      prefixIcon:
                          Icon(Icons.text_fields_outlined, color: Colors.grey)),
                ).copyWith(),
                BoringTextField(
                  //onChanged: (val) => print(val),
                  minLines: 5,
                  maxLines: 6,
                  fieldController:
                      BoringFieldController(validationFunction: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo richiesto";
                    }
                    return null;
                  }),
                  displayCondition: (formValue) =>
                      formValue['test']['check'] ?? true,
                  boringResponsiveSize: BoringResponsiveSize(md: 6, sm: 6),
                  jsonKey: "surname2",
                  decoration: BoringFieldDecoration(
                      label: "Nome",
                      hintText: "Inserisci il nome",
                      prefixIcon:
                          Icon(Icons.text_fields_outlined, color: Colors.grey)),
                ),
              ],
            ),
            BoringTableField(
              groupActions: true,
              atLeastOneItem: false,
              actionGroupTextStyle: TextStyle(color: Colors.amber),
              groupActionsMenuShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              copyIconWidget: const Icon(
                Icons.copyright_sharp,
                color: Colors.pink,
              ),
              deleteIconWidget: const Icon(
                Icons.delete_sweep,
                color: Colors.blueAccent,
              ),
              copyActionText: "COPIAAA",
              deleteActionText: "ELIMINAA",
              jsonKey: 'table',
              tableFormDecoration: BoringTableFormDecoration(
                  tableTitle: Text('PROVA'), showAddButton: true),
              items: [
                BoringDropDownField(
                  jsonKey: 'drop',
                  items: [
                    DropdownMenuItem(
                      child: Text('PIPPPOASDASDASDASDASD'),
                      value: 'PIPPO',
                    ),
                  ],
                ),
                BoringTextField(
                  fieldController:
                      BoringFieldController(validationFunction: (value) {
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
                ),
              ],
              tableHeader: [
                TableHeaderElement(
                    label: 'Colonna 0', alignment: TextAlign.center),
                TableHeaderElement(
                    label: 'Colonna 1', alignment: TextAlign.center),
              ],
            ),
          ],
        ),
        ElevatedButton(
            onPressed: () {
              print(fc.changed);
            },
            child: Text("GET"))
      ],
    );
  }
}
