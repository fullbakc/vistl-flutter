import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:vistl/features/translation/presentation/bloc/translation_bloc.dart';
import 'package:vistl/features/translation/presentation/bloc/translation_state.dart';
import 'package:vistl/features/translation/presentation/pages/capture_page.dart';

class MockTranslationBloc extends Mock implements TranslationBloc {}

void main() {
  late MockTranslationBloc mockBloc;

  setUp(() {
    mockBloc = MockTranslationBloc();

    // Set the initial state of the mock BLoC
    when(() => mockBloc.state).thenReturn(TranslationInitial());
    when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets(
    'Should render initial UI with Image placeholder and Select button',
    (WidgetTester tester) async {
      // Arrange: Build our app and trigger a frame
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TranslationBloc>.value(
            value: mockBloc,
            child: const CapturePage(),
          ),
        ),
      );

      // Assert: Verify the new Image Picker UI elements are on the screen!
      expect(find.text('No image selected'), findsOneWidget);
      expect(find.text('Select Image to Translate'), findsOneWidget);
    },
  );
}
