// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opsmate/main.dart';

// Create a mock AuthBloc for testing
class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    // Setup default state
    when(() => mockAuthBloc.state).thenReturn(const AuthState());
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      BlocProvider<AuthBloc>.value(value: mockAuthBloc, child: const MyApp()),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
