import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

// Update 'vistl' to your actual project name if it's different!
import 'package:vistl/features/translation/presentation/bloc/translation_bloc.dart';
import 'package:vistl/features/translation/presentation/bloc/translation_state.dart';
import 'package:vistl/features/translation/presentation/pages/capture_page.dart';

// 1. Create a Mock class for the TranslationBloc
class MockTranslationBloc extends Mock implements TranslationBloc {}

void main() {
  late MockTranslationBloc mockBloc;

  setUp(() {
    mockBloc = MockTranslationBloc();

    // 2. Set the initial state of the mock BLoC
    when(() => mockBloc.state).thenReturn(TranslationInitial());
    when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

    // Ignore any events added to the mock BLoC during the test
    // when(() => mockBloc.add(any())).thenReturn(null);
  });

  testWidgets('Should show validation error when translating with empty text', (
    WidgetTester tester,
  ) async {
    // 3. Arrange: Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TranslationBloc>.value(
          value: mockBloc,
          child: const CapturePage(),
        ),
      ),
    );

    // Ensure the error message is NOT visible at the start
    expect(find.text('Text cannot be empty'), findsNothing);

    // 4. Act: Find the button and tap it without entering text
    final button = find.text('Capture & Translate Area');
    await tester.tap(button);

    // Rebuild the UI after the tap
    await tester.pumpAndSettle();

    // 5. Assert: The validation error message should now be on the screen
    expect(find.text('Text cannot be empty'), findsOneWidget);
  });
}
