import 'package:file_explorer/popin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('popin works', (tester) async {
    await tester.pumpWidget(
      const FileExplorerPopin(
        directory: '/',
        showHidden: false,
      ),
    );

    // Expect visible "File name text field"
    expect(find.bySemanticsLabel('File name text field'), findsOneWidget);

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
