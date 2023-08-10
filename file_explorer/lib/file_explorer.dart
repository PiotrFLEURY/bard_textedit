library file_explorer;

import 'dart:io';

import 'package:file_explorer/popin.dart';
import 'package:flutter/material.dart';

Future<File?> pickFiles({
  required BuildContext context,
  List<String> extensions = const [],
  String? directory,
  bool showHidden = false,
}) async {
  // Show modal dialog to pick a file.
  String? pickedPath = await showDialog<String>(
    context: context,
    builder: (context) => _fileExplorerPopin(
      context,
      directory,
      showHidden,
      extensions,
    ),
  );

  if (pickedPath == null) return null;

  return File(pickedPath);
}

Widget _fileExplorerPopin(
  BuildContext context,
  String? initDir,
  bool showHidden,
  List<String>? extensions,
) {
  return FileExplorerPopin(
    directory: '/', // initDir ?? homeDirectory() ?? '/',
    showHidden: showHidden,
    extensions: extensions ?? [],
  );
}

// Get the home directory or null if unknown.
String? homeDirectory() {
  switch (Platform.operatingSystem) {
    case 'linux':
    case 'macos':
      return Platform.environment['HOME'];
    case 'windows':
      return Platform.environment['USERPROFILE'];
    case 'android':
      // Probably want internal storage.
      return '/storage';
    case 'ios':
      // iOS doesn't really have a home directory.
      return null;
    default:
      return null;
  }
}
