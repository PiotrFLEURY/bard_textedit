import 'package:bard_textedit/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration smoke tests', () {
    testWidgets('Write text and save', (tester) async {
      // Load app
      await tester.pumpWidget(const MyApp());

      // Press on "Text area"
      await tester.tap(find.bySemanticsLabel('Text area'));

      await tester.pumpAndSettle();

      // Enter "Hello world"
      await tester.enterText(find.bySemanticsLabel('Text area'), 'Hello world');

      await tester.pumpAndSettle();

      // Press on "Save file action button"
      await tester.tap(find.bySemanticsLabel('Save file action button'));

      await tester.pumpAndSettle();

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
  });
}
