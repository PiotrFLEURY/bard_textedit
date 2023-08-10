import 'dart:io';

import 'package:file_explorer/file_explorer.dart' as file_explorer;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _textController = TextEditingController();

  bool _semanticsEnabled = false;

  _toogleSemantics() {
    setState(() {
      _semanticsEnabled = !_semanticsEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showSemanticsDebugger: _semanticsEnabled,
      title: 'Flutter Text Editor',
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () => _saveFile(context),
                tooltip: 'Save file',
              ),
              IconButton(
                icon: const Icon(Icons.menu_open),
                onPressed: () => _loadFile(context),
                tooltip: 'Load file',
              ),
              IconButton(
                icon: const Icon(Icons.accessibility),
                onPressed: () => _toogleSemantics(),
                tooltip: 'Toggle semantics',
              ),
            ],
          ),
          body: Container(
            color: Colors.grey[300],
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Semantics(
                  label: 'Text area',
                  child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: null,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _saveFile(BuildContext context) async {
    // Get the text from the text field.
    String text = _textController.text;
    // Pick a file path on which to save the file using FilePicker.
    File? file = await file_explorer.pickFiles(
      context: context,
      extensions: ['txt'],
    );

    if (file == null) return;

    // Create the file if it doesn't exist.
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    // Save the text in the file.
    await file.writeAsString(text);
  }

  void _loadFile(BuildContext context) async {
    // Get the path to the file to open.
    File? file = await file_explorer.pickFiles(
      context: context,
      extensions: ['txt'],
    );

    if (file == null) return;

    // Load the text from the file.
    String text = await file.readAsString();

    // Set the text in the TextField.
    _textController.text = text;
  }
}
