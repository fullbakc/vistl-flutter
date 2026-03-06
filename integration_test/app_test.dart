// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// IMPORTANT: Change 'vistl' to your actual project name!
import 'package:vistl/main.dart' as app;

void main() {
  // 1. Initialize the Integration Test binding
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'End-to-End Test: Open App -> Enter Data -> Translate -> Check History',
    (WidgetTester tester) async {
      // 2. Start the app
      app.main();

      // Wait for the app to completely boot up (including DB initialization)
      await tester.pumpAndSettle();

      // 3. Find the text field and enter dummy text
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget); // Verify the text field exists
      await tester.enterText(textField, 'Testing translation offline');
      await tester.pumpAndSettle();

      // 4. Tap the "Capture & Translate Area" button
      final translateButton = find.text('Capture & Translate Area');
      await tester.tap(translateButton);

      // Wait for the BLoC to process, DB to save, and animations to finish.
      // We add a longer timeout here just in case the Gemini API takes a second.
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 5. Navigate to the History Page
      // We find the history icon in the AppBar and tap it
      final historyIcon = find.byIcon(Icons.history);
      await tester.tap(historyIcon);

      // Wait for the navigation animation to the new page to finish
      await tester.pumpAndSettle();

      // 6. Verify the data appears in the History List!
      // We expect to find the exact text we typed earlier showing up in the list view.
      expect(find.text('Testing translation offline'), findsWidgets);
    },
  );
}
