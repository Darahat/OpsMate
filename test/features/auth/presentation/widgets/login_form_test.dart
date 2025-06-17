import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opsmate/features/auth/presentation/widgets/auth_form.dart';

// Create a mock class for AuthBloc
class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();

    // Register fallback values for AuthEvent and AuthState
    registerFallbackValue(const LoginEvent(email: '', password: ''));

    // Setup the mock to return a default state
    when(() => mockAuthBloc.state).thenReturn(const AuthState());
  });

  testWidgets('Login form displays all required elements', (
    WidgetTester tester,
  ) async {
    // Build the login form widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const AuthForm(isLogin: true),
          ),
        ),
      ),
    );

    // Verify all required elements are present
    expect(find.text('Welcome back!'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Create an account'), findsOneWidget);

    // Verify name field is NOT present in login mode
    expect(find.text('name'), findsNothing);
  });

  testWidgets('Login form validates input fields', (WidgetTester tester) async {
    // Build the login form widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const AuthForm(isLogin: true),
          ),
        ),
      ),
    );

    // Try to submit without entering any data
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify validation messages appear
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Login form submits when valid data is entered', (
    WidgetTester tester,
  ) async {
    // Build the login form widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const AuthForm(isLogin: true),
          ),
        ),
      ),
    );

    // Enter valid data
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'test@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');

    // Submit the form
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify that the login event was dispatched to the bloc
    verify(() => mockAuthBloc.add(any(that: isA<LoginEvent>()))).called(1);
  });
}
