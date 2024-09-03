import 'dart:async';

import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class FormExample0 extends StatelessWidget {
  FormExample0({super.key});

  final c = BoringFormController(
    initialValue: {
      'num': 123456,
      'info': {'nome': "PIPPO"},
    },
    validationBehaviour: ValidationBehaviour.onSubmit,
    fieldRequiredLabelBehaviour: FieldRequiredLabelBehaviour.always,
  );

  final myStyle = BoringFormStyle(
    inputDecoration: const InputDecoration(
      border: OutlineInputBorder(),
    ),
    labelOverField: false,
    textStyle: const TextStyle(color: Colors.red),
    eraseValueWidget: const Icon(Icons.abc_outlined),
  );

  final titleStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BoringForm(
          style: (context) => myStyle,
          formController: c,
          child: Column(
            children: [
              BoringNumberField(
                fieldPath: ['num'],
                decimalPlaces: 0,
                decimalSeparator: ',',
                thousandsSeparator: '.',
                decoration: (formController) =>
                    BoringFieldDecoration(label: 'Data'),
              ),
              ElevatedButton(
                  onPressed: () {
                    c.resetFields([
                      ['info']
                    ]);
                  },
                  child: const Text("RESET VALUE")),
              ElevatedButton(
                  onPressed: () {
                    c.setFieldValue(["nome"], "(${c.getValue(["nome"])})");
                  },
                  child: const Text("SET NAME")),
              ElevatedButton(
                  onPressed: () {
                    c.setFieldValue(
                        ["cognome"], "[${c.getValue(["cognome"])}]");
                  },
                  child: const Text("SET SURNAME")),
              ElevatedButton(
                  onPressed: () {
                    print(c.value);
                  },
                  child: const Text("PRINT")),
              ElevatedButton(onPressed: () {}, child: const Text("VAL FUNCS")),
              BoringSwitchField(
                fieldPath: ["test"],
                decoration: (_) => BoringFieldDecoration(label: "TESTTEST"),
              ),
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
                                            fieldPath: const ['sss'],
                                          ))),
                                      BoringFormWithTitle(
                                          title: 'asd',
                                          form: BoringForm(
                                              child: BoringTextField(
                                            fieldPath: const ['sss'],
                                          ))),
                                    ],
                                  ),
                                ),
                                FilledButton(
                                    onPressed: () {
                                      print(formController.value);
                                    },
                                    child: const Text('print valuee')),
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
        ),
      ],
    );
  }
}

class FormDialog extends BDialogInfo {
  @override
  String get confirmButtonText => 'Esci';

  @override
  Widget get content => BFormtest();

  @override
  FutureOr<void> onConfirm(BuildContext context) {
    Navigator.pop(context);
  }
}

class BFormtest extends BoringResponsiveFormWidget {
  @override
  List<Widget> get children => [
        BResponsiveChild(
            xs: 4,
            child: BoringTextField(
              fieldPath: ['Ciao'],
              decoration: (formController) =>
                  BoringFieldDecoration(label: 'questa label deve '),
            )),
        BResponsiveChild(
            xs: 8,
            child: BoringTextField(
              fieldPath: ['Ciao'],
              decoration: (formController) => BoringFieldDecoration(
                  label:
                      'questa label deve essere lunga per vedere come e se si tronca quando viene schiacciata'),
            )),
        BResponsiveChild(
            child: BoringTextField(
          fieldPath: ['Ciao'],
          decoration: (formController) => BoringFieldDecoration(
              label:
                  'questa label deve essere lunga per vedere come e se si tronca quando viene schiacciata'),
        )),
        BResponsiveChild(
            child: BoringTextField(
          fieldPath: ['Ciao'],
          decoration: (formController) => BoringFieldDecoration(
              label:
                  'questa label deve essere lunga per vedere come e se si tronca quando viene schiacciata'),
        ))
      ];
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
