import 'dart:io';

import 'package:flutter/material.dart';

class FileExplorerPopin extends StatefulWidget {
  const FileExplorerPopin({
    super.key,
    required this.directory,
    required this.showHidden,
    this.extensions = const [],
  });

  final String directory;
  final bool showHidden;
  final List<String> extensions;

  @override
  State<FileExplorerPopin> createState() => _FileExplorerPopinState();
}

class _FileExplorerPopinState extends State<FileExplorerPopin> {
  List<FileSystemEntity> _entities = [];

  late Directory _currentDirectory;
  late TextEditingController _textController;

  bool _listVisible = true;

  _toogleListVisibility() {
    setState(() {
      _listVisible = !_listVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _goToDirectory(Directory(widget.directory));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Toggle list visibility button.
                  IconButton(
                    icon: const Icon(Icons.list),
                    onPressed: () => _toogleListVisibility(),
                    tooltip: 'Toggle list visibility',
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: () {
                      _goToDirectory(_currentDirectory.parent);
                    },
                    tooltip: 'Go up directory',
                  ),
                  // File name text field.
                  Expanded(
                    key: const Key('File name text field'),
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'my_file.txt',
                        helperText: 'Enter a file name',
                      ),
                      onSubmitted: (_) => _confirmSelection(context),
                    ),
                  ),
                  // Extension dropdown.
                  Flexible(
                    child: Text(
                      '*.${widget.extensions.join(', *.')}',
                      semanticsLabel: 'Extension dropdown',
                    ),
                  ),
                  // Save button
                  IconButton(
                    icon: const Icon(Icons.done),
                    onPressed: () => _confirmSelection(context),
                    tooltip: 'Select file',
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              key: const Key('File list'),
              child: Semantics(
                label: 'File list',
                child: Visibility(
                  visible: _listVisible,
                  child: ListView.builder(
                    itemCount: _entities.length,
                    itemBuilder: _filesBuilder,
                    padding: const EdgeInsets.all(24),
                    addSemanticIndexes: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      title: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300],
        ),
        child: SelectionArea(
          child: Text(
            _currentDirectory.path,
          ),
        ),
      ),
    );
  }

  Widget _filesBuilder(BuildContext context, int index) {
    FileSystemEntity entity = _entities[index];
    return ListTile(
      leading: entity is Directory
          ? Icon(
              Icons.folder,
              color: Theme.of(context).primaryColor,
            )
          : const Icon(Icons.insert_drive_file_outlined),
      title: Text(entity.name),
      onTap: () {
        if (entity is Directory) {
          _goToDirectory(entity);
        } else if (entity is File) {
          Navigator.of(context).pop(entity.path);
        }
      },
    );
  }

  _setCurrentDirectory(Directory directory) {
    setState(() {
      _currentDirectory = directory;
    });
  }

  _goToDirectory(Directory directory) {
    setState(() {
      _entities = directory
          .listSync()
          .where((entity) => widget.showHidden || !entity.name.startsWith('.'))
          .where(
            (entity) =>
                entity is Directory ||
                widget.extensions.isEmpty ||
                widget.extensions.contains(entity.extension),
          )
          .toList()
        // Sort directories first, then files.
        ..sort(
          (a, b) {
            if (a is Directory && b is File) {
              return -1;
            } else if (a is File && b is Directory) {
              return 1;
            } else {
              return a.path.compareTo(b.path);
            }
          },
        );
      _setCurrentDirectory(directory);
    });
  }

  void _confirmSelection(BuildContext context) {
    Navigator.of(context)
        .pop('${_currentDirectory.path}/${_textController.text}');
  }
}

extension FileSystemEntityExt on FileSystemEntity {
  String get name => uri.pathSegments
      .where((segment) => segment.isNotEmpty)
      .last
      .replaceAll('%20', ' ');

  String get extension => name.contains('.') ? path.split('.').last : '';
}
