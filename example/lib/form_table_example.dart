import 'dart:io';
import 'package:boring_form/implementations/choice/boring_multichoice_search_dropdown_field.dart';
import 'package:boring_form/implementations/dialog/boring_stepper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:boring_form/implementations/boring_file_picker.dart';
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

  final fc = BoringFormController();
  final stepperController = BoringFormController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            BoringStepper.showStepperDialog(
              context,
              formController: stepperController,
              jsonKey: 'stepper',
              decoration: BoringStepperDecoration(
                dialogShapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onContinueButton: (details) => ElevatedButton(
                  onPressed: () {
                    details.onStepContinue!.call();
                  },
                  child: Text("PIPPOOO"),
                ),
              ),
              formStyle: BoringFormStyle(
                readOnly: false,
                labelOverField: true,
                inputDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              onConfirmButtonPress: (context, isStepperValid) {
                print(isStepperValid);
              },
              sections: [
                BoringSection(
                  jsonKey: 's1',
                  decoration: BoringFieldDecoration(label: 'Primo step'),
                  fields: [
                    BoringTextField(
                      jsonKey: 'text',
                      fieldController: BoringFieldController(
                        validationFunction: (value) {
                          if (value == null || value.isEmpty) {
                            return "required";
                          }
                        },
                      ),
                    ),
                  ],
                ),
                BoringSection(
                  jsonKey: 's2',
                  decoration: BoringFieldDecoration(label: 'Secondo step'),
                  fields: [
                    BoringTextField(
                      jsonKey: 'text',
                      fieldController: BoringFieldController(
                        validationFunction: (value) {
                          if (value == null || value.isEmpty) {
                            return "required";
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          child: Text("open stepper"),
        ),
        BoringForm(
          formController: fc,
          includeNotDisplayedInValidation: false,
          style: BoringFormStyle(
              readOnly: false,
              labelOverField: true,
              inputDecoration:
                  const InputDecoration(border: OutlineInputBorder())),
          fields: [
            BoringSection(
              jsonKey: 'test',
              fields: [

                BoringNumberField(jsonKey: 'asdas'),

                BoringSearchDropDownField<String>(
                  jsonKey: 'multichoicesearch',
                  onAddIcon: Icon(Icons.add_a_photo),
                  searchMatchFunction: (p0, p1) =>
                      (p0.value as String).contains(p1),
                  onAdd: (value) async {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      },
                    );
                  },
                  onItemAlreadyExisting: (dropdownContext) {
                    Navigator.pop(dropdownContext);
                    SnackBar s =
                        SnackBar(content: Text("l'item è già stato inserito"));
                    ScaffoldMessenger.of(context).showSnackBar(s);
                  },
                  items: [
                    for (String item in ["asd", 'qwe', 'wqe'])
                      DropdownMenuItem(value: item, child: const Text("asd"))
                  ],
                ),
                BoringSwitchField(
                  jsonKey: 'asd',
                  switchDecoration: BoringSwitchDecoration(
                      textWhenActive: Text("yes"),
                      textWhenNotActive: Text("yes"),
                      labelPosition: BoringSwitchLabelPosition.left),
                  decoration: BoringFieldDecoration(label: "asdasd"),
                ),
                BoringNumberField(
                  jsonKey: 'kmSingolaTratta',
                  fieldController: BoringFieldController(),
                  onChanged: (p0) {
                    print("asdasd");
                    print(p0);
                  },
                  decoration: BoringFieldDecoration(
                    label: '_kmSingolaTratta',
                    hintText: "_kilometersHint",
                    icon: Icon(Icons.ads_click, color: Colors.amber),
                  ),
                ),
                BoringFilePicker(
                  verticalAlignment: 1.3,
                  boringResponsiveSize: BoringResponsiveSize(md: 6, sm: 6),
                  feedbackPosition: FeedbackPosition.top,
                  noFilesSelectedText: Text("NESSUN FILE SELEZIONATO"),
                  feedbackTextBuilder: (filesSelected) {
                    if (filesSelected == 1) {
                      return Text("SOLO 1 FILE SELEZIONATO");
                    }
                    return Text("PIU FILE SELEZIONATI");
                  },
                  decoration: BoringFieldDecoration(
                    label: "asdas",
                  ),
                  jsonKey: "filePicker",
                  backgroundColor: Colors.red,
                  allowMultiple: true,
                ),
                BoringDropDownField(
                  boringResponsiveSize: BoringResponsiveSize(md: 6, sm: 6),
                  jsonKey: 'dropdown',
                  items: [
                    DropdownMenuItem(
                      value: 'asd',
                      child: Text('asd'),
                    )
                  ],
                  decoration: BoringFieldDecoration(label: "this is a label"),
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
                  decoration: BoringFieldDecoration(
                      label: "Nome",
                      hintText: "Inserisci il nome",
                      prefixIcon:
                          Icon(Icons.text_fields_outlined, color: Colors.grey)),
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
              print((fc.value!["test"]["filePicker"]));
            },
            child: Text("GET"))
      ],
    );
  }
}
