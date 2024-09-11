import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

import 'form_example.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = DefaultBoringUI.defaultThemeData(
      colorSchemeSeed: Colors.red,
      brightness: Brightness.light,
      additionalExtensions: [],
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.copyWith(extensions: [
        BUIThemeData.defaultTheme(defaultThemeData: theme),
      ]),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FORMS EXAMPLE")),
      body: SingleChildScrollView(child: FormExample0()),
    );
  }
}
