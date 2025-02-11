import 'dart:async';

import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class User {
  const User({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

final usersRepo = UsersRepo(
  identifier: (p0) => p0.id,
  isValidForParam: (p0, p1) => true,
  mergeUpdate: (p0, p1) => p0,
  converter: (p0) => p0,
);

class UsersRepo extends BoringRxRepo<User, User, int, int, int> {
  UsersRepo(
      {required super.identifier,
      required super.isValidForParam,
      required super.mergeUpdate,
      required super.converter});

  final _list = [
    User(id: 1, name: 'Uno'),
    User(id: 2, name: 'Due'),
    User(id: 3, name: 'Tre'),
    User(id: 4, name: 'Quattro'),
  ];

  @override
  Future<List<User>> fetchMulti(int param) async {
    await Future.delayed(const Duration(seconds: 2));
    return _list;
  }

  @override
  Future<User> fetchSingle(int id, int param) async {
    await Future.delayed(const Duration(seconds: 2));

    return _list.firstWhere((element) => element.id == id);
  }

  @override
  Duration get ttl => const Duration(minutes: 2);
}

class FormExample0 extends StatelessWidget {
  FormExample0({super.key});

  final c = BoringFormController(
    initialValue: {'mammt' : 123456.78},
    deferredFields: {
      ['user']: DeferredValue<UsersRepo, User>(
        listenable: usersRepo,
        selector: (listenable) => listenable.readSingle(2, 2),
      ),
    },
    validationBehaviour: ValidationBehaviour.always,
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

  final firstDate = DateTime.now();
  final lastDate = DateTime.now().add(const Duration(days: 365));

  void onChanged() {
    final num1 = c.getValue(['num1']) as num? ?? 0;
    final num2 = c.getValue(['num2']) as num? ?? 0;
    c.setFieldValue(['num3'], num1 + num2);
  }

  final users = [
    User(id: 1, name: 'Uno'),
    User(id: 2, name: 'Due'),
    User(id: 3, name: 'Tre'),
    User(id: 4, name: 'Quattro'),
  ];

  @override
  Widget build(BuildContext context) {
    c.addFieldsListener(
      key: 'calcoloMoltiplicazione',
      fields: [
        ['num1'],
        ['num2'],
      ],
      callback: onChanged,
    );

    c.addFieldsListener(
      key: 'calcoloAddizione',
      fields: [
        ['num1'],
        ['num2'],
      ],
      callback: onChanged,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BoringForm(
          style: (context) => myStyle,
          formController: c,
          child: Column(
            children: [
              BoringNumberField(
                fieldPath: ['mammt'],
                decimalSeparator: ',',
                thousandsSeparator: '.',
                decimalPlaces: 3,
              ),

              BButton(onPressed: () {

                c.setFieldValue(['mammt'], 33.33);

              }, text: 'set',),

              BoringDeferredField<UsersRepo, User>(
                fieldPath: ['user'],
                builder: (fieldPath) => BoringDropdownField<User>(
                  fieldPath: fieldPath,
                  getItems: (search) async {
                    return await usersRepo.readMultiFuture(0);
                  },
                  toBoringChoiceItem: (element) {
                    return BChoiceItem(value: element, display: element.name);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final readOnlyStatus = c.isFieldReadOnly(['user']);

                  c.setFieldReadOnlyStatus(['user'], readOnly: !readOnlyStatus);
                },
                child: const Text('Set readonly'),
              ),
              const Divider(),
              BoringNumberField(fieldPath: ['num1']),
              BoringFormChildWidget(
                observedFields: [
                  ['num1']
                ],
                builder: (context, fc) {
                  final num1 = fc.getValue(['num1']);
                  return BoringNumberField(
                    //readOnly: num1 == null,
                    fieldPath: ['num2'],
                  );
                },
              ),
              BoringNumberField(
                fieldPath: ['num3'],
                onChanged: (formController, fieldValue) {
                  if (fieldValue == 111) {
                    print('setting read onyl!');
                    formController
                        .setFieldReadOnlyStatus(['num1'], readOnly: true);
                  }
                },
              ),
              BoringDateTimeField(
                fieldPath: ["dateTimeField"],
                firstDate: firstDate,
                lastDate: lastDate,
              ),
              BoringRRuleField(
                fieldPath: ["rrule"],
              ),
              BoringDropdownField<int>(
                fieldPath: ['test'],
                getItems: (_) async {
                  return List.generate(10000, (e) => e);
                },
                toBoringChoiceItem: (e) {
                  return BChoiceItem<int>(
                    value: e,
                    display: e.toString(),
                  );
                },
              ),
              BoringDropdownMultiChoiceField(
                fieldPath: ['test1'],
                getItems: (_) async {
                  return List.generate(10000, (e) => e);
                },
                toBoringChoiceItem: (e) {
                  return BChoiceItem<int>(
                    value: e,
                    display: e.toString(),
                  );
                },
              ),
              BoringFilePickerV2(
                fieldPath: ['file'],
                decoration:
                    BoringFilePickerDecoration(allowedExtensions: ['png']),
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
                fieldPath: ["test-bool"],
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
