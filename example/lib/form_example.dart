import "package:boring_form/boring_form.dart";
import 'package:boringcore/boring_dropdown.dart';
import 'package:flutter/material.dart';

class FormExample0 extends StatelessWidget {
  FormExample0({super.key});

  final c = BoringFormController(initialValue: {'num': 123456});

  final myStyle = BoringFormStyle(
      inputDecoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      labelOverField: true,
      textStyle: TextStyle(color: Colors.red),
      eraseValueWidget: Icon(Icons.abc_outlined));

  final titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return BoringForm(
      style: (context) => myStyle,
      formController: c,
      child: Column(
        children: [
          BoringImagePickerWithPreview(
            fieldPath: ["image"],
            imagePickerWithPreviewDecoration:
                BoringImagePickerWithPreviewDecoration(
              previewImageWrapper: (context, child) => ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 100),
                child: child,
              ),
            ),
          ),
          /* Text("Choice", style: titleStyle),
          Text("checkbox"),
          BoringCheckBoxField(
            fieldPath: ["check"],
            validationFunction: (formController, value) =>
                value == false || value == null ? "Insert value" : null,
            decoration: (formController) => BoringFieldDecoration(
              label: "ciaotest123",
            ),
          ),
          Text("radio group"),
          BoringRadioGroupField(
            fieldPath: ["group"],
            items: [
              BoringChoiceItem(value: "test", display: "test"),
              BoringChoiceItem(value: "asd", display: "asd"),
            ],
          ),
          Text("switch"),
          BoringSwitchField(fieldPath: ["switch"]),
          Text("Multichoice dropdown"),
          BoringDropdownMultiChoiceField(
            fieldPath: ["multi"],
            getItems: (search) async => await List.generate(20,
                (index) => BoringChoiceItem(value: index, display: "$index")),
            toBoringChoiceItem: (p0) =>
                BoringChoiceItem(value: p0, display: "$p0"),
            decoration: (formController) => BoringFieldDecoration(
                label: 'LABEL', hintText: 'THIS IS THE HINT'),
            validationFunction: (formController, value) =>
                (value?.length ?? 0) < 3 ? "almeno 3 elementi" : null,
          ),*/
          Text("Singlechoice dropdown"),
          BoringDropdownField(
            fieldPath: ["single", 'test'],
            getItems: (search) async => await List.generate(20,
                (index) => BoringChoiceItem(value: index, display: "$index")),
            toBoringChoiceItem: (p0) =>
                BoringChoiceItem(value: p0, display: "$p0"),
            decoration: (formController) => BoringFieldDecoration(label: "AA"),
            validationFunction: (formController, value) =>
                (value == null) ? "seleziona un elemento" : null,
          ),
          //////////////////////////////
          // Text("Pickers", style: titleStyle),
          // Text("Date field"),
          // BoringDateField(
          //     fieldPath: ["date"],
          //     firstDate: DateTime.now(),
          //     validationFunction: (formController, value) =>
          //         value == null ? "Insert value" : null,
          //     lastDate: DateTime.now().add(const Duration(days: 300))),
          // Text("Datetime field"),
          // BoringDateTimeField(
          //     fieldPath: ["datetime"],
          //     firstDate: DateTime.now(),
          //     validationFunction: (formController, value) =>
          //         value == null ? "Insert value" : null,
          //     lastDate: DateTime.now().add(const Duration(days: 300))),
          // Text("Time field"),
          // BoringTimeField(
          //   fieldPath: ["timefield"],
          //   validationFunction: (formController, value) =>
          //       value == null ? "Insert value" : null,
          // ),
          // Text("File picker"),
          // BoringFilePicker(
          //   fieldPath: ["file"],
          //   validationFunction: (formController, value) =>
          //       value == null ? "Insert value" : null,
          // ),
          // //////////////////////////////
          Text("Number fields", style: titleStyle),

          Text("number"),
          BoringNumberField(
            fieldPath: ["num"],
            decimalSeparator: '.',
            thousandsSeparator: ',',
            decimalPlaces: 2,
            validationFunction: (formController, value) =>
                value == null ? "Insert value" : null,
          ),
          // Text("slider"),
          // BoringSlider(
          //   fieldPath: ["slider"],
          // ),
          // /////////////////////////////
          // Text("Text fields", style: titleStyle),
          // Text("email"),
          // BoringEmailField(
          //   fieldPath: ["email"],
          //   invalidEmailMessage: "invalid email",
          //   validationFunction: (formController, value) =>
          //       value == null ? "Insert value" : null,
          // ),
          // Text("password"),
          // BoringPasswordField(
          //   fieldPath: ["password"],
          //   validationFunction: (formController, value) =>
          //       value == null ? "Insert value" : null,
          // ),
          // Text("phone"),
          // BoringPhoneNumberField(
          //   fieldPath: ["phone"],
          //   invalidPhoneMessage: "Invalid phone",
          // ),
          Text("Text"),
          BoringTextField(
            fieldPath: ["text"],
            decoration: (formController) =>
                BoringFieldDecoration(label: 'labell'),
            validationFunction: (formController, value) =>
                value == null ? "Insert value" : null,
          ),
          // const Text("CIAO LEO"),
          // BoringFormChildWidget(
          //     observedFields: const [
          //       ["cognome"],
          //       ["anag", "nome"]
          //     ],
          //     builder: (context, formController) {
          //       return Text("${formController.getValue([
          //             'nome'
          //           ])} ${formController.getValue([
          //             'cognome'
          //           ])} ${formController.getValue(
          //         ['anag', 'nome'],
          //       )}");
          //       // return Text(formController.value["asd"]);
          //     }),
          BoringFormChildWidget(

              // observedFields: [
              //   ['single', 'test'],
              //   ['multi'],
              // ],
              builder: (context, formController) {
            // print(formController.value);

            return const Text("WATCHER");
            // return Text(formController.value["asd"]);
          }),
          BoringPasswordField(
            // allowEmpty: true,
            fieldPath: const ["anag", "nome"],
            validationFunction: (formController, value) =>
                ((value?.length ?? 0) > 8) ? null : "Password at least 8 chars",
          ),
          // const BoringSlider(
          //   fieldPath: ["test", "num"],
          // ),
          ElevatedButton(
              onPressed: () {
                c.setFieldValue(["nome"], "(${c.getValue(["nome"])})");
              },
              child: const Text("SET NAME")),
          ElevatedButton(
              onPressed: () {
                c.setFieldValue(["cognome"], "[${c.getValue(["cognome"])}]");
              },
              child: const Text("SET SURNAME")),
          ElevatedButton(
              onPressed: () {
                print(c.value);
              },
              child: const Text("PRINT")),
          ElevatedButton(
              onPressed: () {
                c.value = {
                  "nome": "Francesco",
                  "cognome": "De Salvo",
                  "anag": {"nome": "TextField"},
                  "test": {"num": 0.5}
                };
              },
              child: const Text("SET FORM VALUE")),
          ElevatedButton(
              onPressed: () {
                print("IS-VALID: ${c.isValid}");
              },
              child: const Text("IS VALID")),
          ElevatedButton(
              onPressed: () {
                print("CHANGED: ${c.hasChanged}");
              },
              child: const Text("CHANGED")),
          ElevatedButton(
              onPressed: () {
                final formController = BoringFormController();
                final _stepNotifier = ValueNotifier(0);
                showDialog(
                  context: context,
                  builder: (context) => BoringForm(
                    formController: formController,
                    child: AlertDialog(
                      content: SizedBox(
                        width: 700,
                        height: 700,
                        child: Column(
                          children: [
                            Expanded(
                              child: BoringFormStepper(
                                mustBeValidToContinue: false,
                                forms: [
                                  BoringFormWithTitle(
                                      title: 'asd',
                                      form: BoringForm(
                                          child: BoringTextField(
                                        fieldPath: ['sss'],
                                      ))),
                                  BoringFormWithTitle(
                                      title: 'asd',
                                      form: BoringForm(
                                          child: BoringTextField(
                                        fieldPath: ['sss'],
                                      ))),
                                ],
                              ),
                            ),
                            FilledButton(
                                onPressed: () {
                                  print(formController.value);
                                },
                                child: Text('print valuee')),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const Text("OPEN STEPPER")),
        ],
      ),
    );
  }
}

// class FormExample2 extends StatelessWidget {
//   final formController = BoringFormController(initialValue: {
//     "endDate": ['25']
//   });
//   final textFieldController = BoringFieldController<String>(
//     validationFunction: (value) =>
//         (value == null || value.isEmpty) ? "Campo richiesto" : null,
//   );

//   final ValueNotifier<int> _counter = ValueNotifier(0);

//   Widget profileForm(BuildContext context) {
//     return SingleChildScrollView(
//       child: ValueListenableBuilder(
//         valueListenable: _counter,
//         builder: (context, value, child) => Column(
//           children: [
//             ElevatedButton(
//                 onPressed: () {
//                   _counter.value = ++_counter.value;
//                 },
//                 child: Text('fai qualcosa')),
//             Text(value.toString()),
//             BoringForm(
//               formController: formController,
//               style: BoringFormStyle(
//                   //readOnly: true,
//                   inputDecoration:
//                       InputDecoration(border: OutlineInputBorder()),
//                   labelOverField: true,
//                   sectionTitleStyle: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold)),
//               fields: [
//                 BoringNumberField(
//                   jsonKey: 'sdaasd',
//                   onlyIntegers: true,
//                 ),
//                 BoringConnectedField<String?, String?>(
//                     childJsonKey: 'connection',
//                     pathToConnectedJsonKey: [
//                       'test1',
//                     ],
//                     childBuilder: (context, connectedToValue) =>
//                         BoringSearchDropDownField<String>(
//                           jsonKey: 'connection',
//                           key: GlobalKey(),
//                           items: connectedToValue != null
//                               ? [
//                                   DropdownMenuItem(
//                                       value: connectedToValue,
//                                       child: Text(connectedToValue))
//                                 ]
//                               : [],
//                         ),
//                     formController: formController),
//                 BoringTextField(jsonKey: 'test1'),
//               ],
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   print("FORM VALUE ${formController.isValid}");
//                   print("FORM VALUE ${formController.value}");
//                 },
//                 child: Text("GET INFO")),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return profileForm(context);
//   }
// }
