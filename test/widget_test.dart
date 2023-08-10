// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:bard_textedit/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Press on "Text area"
    await tester.tap(find.bySemanticsLabel('Text area'));

    // Enter "Hello world"
    await tester.enterText(find.bySemanticsLabel('Text area'), 'Hello world');

    // Press on "Save file action button"
    await tester.tap(find.bySemanticsLabel('Save file action button'));

    // Expect visible "File name text field"
    expect(find.bySemanticsLabel('File name text field'), findsOneWidget);

    // Press on "File name text field"
    await tester.tap(find.bySemanticsLabel('File name text field'));

    // Enter "hello.txt"
    await tester.enterText(
        find.bySemanticsLabel('File name text field'), 'hello.txt');

    // Submit
    await tester.testTextInput.receiveAction(TextInputAction.done);
  });
}
