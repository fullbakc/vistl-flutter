import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vistl/main.dart'
    as app; // Make sure this matches your project name!

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-End Test: Verify Image UI and Navigate to History', (
    WidgetTester tester,
  ) async {
    // 1. Boot up the entire application
    app.main();

    // Wait for the databases to initialize and UI to render
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 2. Verify the new Capture Page UI is present
    expect(find.text('No image selected'), findsOneWidget);
    expect(find.text('Select Image to Translate'), findsOneWidget);
    expect(find.byIcon(Icons.photo_library), findsOneWidget);

    // 3. Find and tap the History icon in the AppBar
    final historyIcon = find.byIcon(Icons.history);
    expect(historyIcon, findsOneWidget);
    await tester.tap(historyIcon);

    // 4. Wait for the page transition animation to finish
    await tester.pumpAndSettle();

    // 5. Verify the router successfully navigated away from the Capture Page
    // (The 'Select Image' button should no longer be on the screen)
    expect(find.text('Select Image to Translate'), findsNothing);
  });
}
