import 'package:boring_form/implementations/choice/boring_multichoice_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import "package:boring_form/boring_form.dart";

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
          style: BoringFormStyle(readOnly: false),
          fields: [
            BoringSection(jsonKey: 'test', fields: [
              BoringMultiChoiceDropDownField<User>(
                resultTextStyle: TextStyle(color: Colors.red),
                itemsTextStyle: TextStyle(color: Colors.amber),
                boringResponsiveSize: BoringResponsiveSize(md: 2),
                jsonKey: 'multi',
                items: [
                  User('pippo'),
                  User('pluto'),
                  User('sd'),
                  User('plutdaso'),
                  User('plutdso'),
                  User('pludsato'),
                ],
                convertItemToString: (item) {
                  return item.username;
                },
                checkedIcon: const Icon(Icons.star),
                uncheckedIcon: const Icon(Icons.star_border),
              ),
            ]),
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
                      prefixIcon:
                          Icon(Icons.text_fields_outlined, color: Colors.grey)),
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
              ],
              tableHeader: [],
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
