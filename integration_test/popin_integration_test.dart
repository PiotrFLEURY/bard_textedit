import 'package:file_explorer/popin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('popin works', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FileExplorerPopin(
          directory: '/',
          showHidden: false,
        ),
      ),
    );

    // Expect visible "File name text field"
    expect(
        find.bySemanticsLabel(
          RegExp(
            r'File name text field',
          ),
        ),
        findsOneWidget);

    // Press on "File name text field"
    await tester.tap(find.bySemanticsLabel('File name text field'));

    await tester.pumpAndSettle();

    // Enter "hello.txt"
    await tester.enterText(
        find.bySemanticsLabel('File name text field'), 'hello.txt');

    await tester.pumpAndSettle();

    // Submit
    await tester.testTextInput.receiveAction(TextInputAction.done);

    await tester.pumpAndSettle();
  });
}
