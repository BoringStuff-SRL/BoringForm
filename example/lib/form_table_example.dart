import 'package:boring_form/implementations/choice/boring_multichoice_dropdown_field.dart';
import 'package:boring_form/implementations/choice/boring_switch_field.dart';
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

  final fc = BoringFormController(
    initialValue: {
      'sections': [
        {'drop': "PIPPO"},
        {'drop': "PIPPO"}
      ]
    },
  );
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
                BoringSwitchField(
                  jsonKey: 'switch',
                  boringResponsiveSize: BoringResponsiveSize(sm: 6, md: 6),
                  switchDecoration: BoringSwitchDecoration(
                      textWhenActive: Text('ATTIVO'),
                      textWhenNotActive: Text('NON ATTIVO'),
                      widthWhenActive: 110,
                      borderRadius: BorderRadius.circular(6),
                      widthWhenNotActive: 135),
                  decoration: BoringFieldDecoration(label: 'This is my label'),
                ),
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
                  displayCondition: (formValue) => formValue['test']['check'],
                  boringResponsiveSize: BoringResponsiveSize(md: 6, sm: 6),
                  jsonKey: "surname2",
                  decoration: BoringFieldDecoration(
                      label: "Nome",
                      hintText: "Inserisci il nome",
                      prefixIcon:
                          Icon(Icons.text_fields_outlined, color: Colors.grey)),
                ),
                BoringCheckBoxField(
                    jsonKey: 'check',
                    fieldController:
                        BoringFieldController(initialValue: false)),
              ],
            ),
            BoringTableField(
              groupActions: true,
              atLeastOneItem: true,
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
              jsonKey: 'sections',
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
                BoringDateField(
                    jsonKey: "DATE",
                    firstlDate:
                        DateTime.now().subtract(const Duration(days: 12)),
                    lastDate: DateTime.now().add(const Duration(days: 12))),
              ],
              tableHeader: [
                TableHeaderElement(
                    label: 'Colonna 0', alignment: TextAlign.center),
                TableHeaderElement(
                    label: 'Colonna 1', alignment: TextAlign.center),
                TableHeaderElement(
                    label: 'Colonna 2', alignment: TextAlign.center),
              ],
            ),
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
