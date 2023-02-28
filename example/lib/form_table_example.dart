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

  final fc = BoringFormController(initialValue: {});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BoringForm(
          formController: fc,
          style: BoringFormStyle(
              readOnly: false,
              inputDecoration:
                  const InputDecoration(border: OutlineInputBorder())),
          fields: [
            BoringSection(jsonKey: 'test', fields: [
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
              BoringCheckBoxField(
                jsonKey: 'check',
                mainAxisAlignment: MainAxisAlignment.center,
                boringResponsiveSize: BoringResponsiveSize(md: 6, sm: 6),
              ),
            ]),
            BoringTableField(
              groupActions: true,
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
                    onChanged: (p0) {},
                    items: [
                      DropdownMenuItem(
                        child: Text('PIPPPO'),
                        value: 'PIPPO',
                      ),
                    ]),
                BoringTextField(
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
                ),
                BoringCheckBoxField(
                  jsonKey: 'asd',
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
              tableFieldController: BoringTableFieldController(initialValue: [
                {'asd': true, 'drop': 'PIPPO'}
              ]),
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
