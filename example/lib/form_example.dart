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

class FormExample0 extends BoringResponsiveFormWidget {
  FormExample0({super.key})
      : super(
          formController: BFormController(
            initialValue: {
              'address': {
                'country': ["DE"],
                'country1': "DE",
                //  'dropdown': 1,
              },
            },
          ),
        );

  @override
  BoringFormStyle styleManipulator(BoringFormStyle style) {
    return super
        .styleManipulator(style)
        .copyWith(fieldsPadding: const EdgeInsets.all(4));
  }

  @override
  List<Widget> get children => [
        BoringRRuleField(
          fieldPath: ['rrule'],
          decoration: (formController) => BoringFieldDecoration(label: 'RRULE'),
        ),
        BoringDateTimeField(
          fieldPath: ['datetime'],
          decoration: (formController) =>
              BoringFieldDecoration(label: 'DATETIME'),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 122)),
        ),
      ];
}
