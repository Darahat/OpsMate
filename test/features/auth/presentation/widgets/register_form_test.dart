import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opsmate/features/auth/presentation/widgets/auth_form.dart';
import 'package:go_router/go_router.dart';

// Create a mock class for AuthBloc
class MockAuthBloc extends Mock implements AuthBloc {}

// Mock GoRouter for navigation
class MockGoRouter extends Mock implements GoRouter {}

// Setup GoRouter mock
class MockGoRouterProvider extends StatelessWidget {
  const MockGoRouterProvider({
    super.key,
    required this.child,
    required this.router,
  });

  final Widget child;
  final MockGoRouter router;

  @override
  Widget build(BuildContext context) {
    return InheritedGoRouter(goRouter: router, child: child);
  }
}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockGoRouter = MockGoRouter();

    // Register fallback values for AuthEvent
    registerFallbackValue(
      const RegisterEvent(name: '', email: '', password: ''),
    );

    // Setup the mock to return a default state
    when(() => mockAuthBloc.state).thenReturn(const AuthState());

    // Setup mock navigation
    when(() => mockGoRouter.go(any())).thenReturn(null);
  });

  Widget createRegisterForm() {
    return MaterialApp(
      home: MockGoRouterProvider(
        router: mockGoRouter,
        child: Scaffold(
          body: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const AuthForm(isLogin: false),
          ),
        ),
      ),
    );
  }

  testWidgets('Registration form displays all required elements', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createRegisterForm());

    // Verify name, email and password fields are present
    expect(find.text('name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Verify sign up button is present
    expect(find.text('Sign Up'), findsOneWidget);

    // Verify "Already have an account? Login" link is present
    expect(find.text('Already have an account? Login'), findsOneWidget);
  });

  testWidgets('Registration form validates input fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createRegisterForm());

    // Tap the sign up button without entering any data
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    // Verify validation error messages are shown
    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Registration form validates password length', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createRegisterForm());

    // Enter valid name and email but short password
    await tester.enterText(
      find.widgetWithText(TextFormField, 'name'),
      'Test User',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'test@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      '12345',
    );

    // Submit the form
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    // Verify password length validation error is shown
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('Registration form submits when valid data is entered', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createRegisterForm());

    // Enter valid data
    await tester.enterText(
      find.widgetWithText(TextFormField, 'name'),
      'Test User',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'test@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'password123',
    );

    // Submit the form
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    // Verify that the register event was dispatched to the bloc
    verify(() => mockAuthBloc.add(any(that: isA<RegisterEvent>()))).called(1);
  });
}
