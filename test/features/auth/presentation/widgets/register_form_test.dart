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

    // Register fallback values for AuthEvent
    registerFallbackValue(
      const RegisterEvent(name: '', email: '', password: ''),
    );

    // Setup the mock to return a default state
    when(() => mockAuthBloc.state).thenReturn(const AuthState());
  });

  testWidgets('Registration form displays all required elements', (
    WidgetTester tester,
  ) async {
    // Build the registration form widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const AuthForm(isLogin: false),
          ),
        ),
      ),
    );

    // Verify all required elements are present
    expect(find.text('Welcome back!'), findsOneWidget);
    expect(find.text('name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Already have an account? Login'), findsOneWidget);
  });

  testWidgets('Registration form validates input fields', (
    WidgetTester tester,
  ) async {
    // Build the registration form widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const AuthForm(isLogin: false),
          ),
        ),
      ),
    );

    // Try to submit without entering any data
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    // Verify validation messages appear
    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Registration form validates password length', (
    WidgetTester tester,
  ) async {
    // Build the registration form widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const AuthForm(isLogin: false),
          ),
        ),
      ),
    );

    // Enter valid name and email but short password
    await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'test@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), '12345');

    // Submit the form
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    // Verify password length validation message appears
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('Registration form submits when valid data is entered', (
    WidgetTester tester,
  ) async {
    // Build the registration form widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const AuthForm(isLogin: false),
          ),
        ),
      ),
    );

    // Enter valid data
    await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'test@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');

    // Submit the form
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    // Verify that the register event was dispatched to the bloc
    verify(() => mockAuthBloc.add(any(that: isA<RegisterEvent>()))).called(1);
  });
}
