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

    // Register fallback values for AuthEvent and AuthState
    registerFallbackValue(const LoginEvent(email: '', password: ''));

    // Setup the mock to return a default state
    when(() => mockAuthBloc.state).thenReturn(const AuthState());

    // Setup mock navigation
    when(() => mockGoRouter.go(any())).thenReturn(null);
  });

  Widget createLoginForm() {
    return MaterialApp(
      home: MockGoRouterProvider(
        router: mockGoRouter,
        child: Scaffold(
          body: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const AuthForm(isLogin: true),
          ),
        ),
      ),
    );
  }

  testWidgets('Login form displays all required elements', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createLoginForm());

    // Verify email and password fields are present
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Verify login button is present
    expect(find.text('Login'), findsOneWidget);

    // Verify "Create an account" link is present
    expect(find.text('Create an account'), findsOneWidget);

    // Verify "Forget Password?" link is present
    expect(find.text('Forget Password?'), findsOneWidget);
  });

  testWidgets('Login form validates input fields', (WidgetTester tester) async {
    await tester.pumpWidget(createLoginForm());

    // Tap the login button without entering any data
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify validation error messages are shown
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Login form submits when valid data is entered', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createLoginForm());

    // Enter valid data
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'test@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'password123',
    );

    // Submit the form
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify that the login event was dispatched to the bloc
    verify(() => mockAuthBloc.add(any(that: isA<LoginEvent>()))).called(1);
  });
}
