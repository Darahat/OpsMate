import 'package:flutter_test/flutter_test.dart';
import 'package:opsmate/injection_container.dart';

///sets up dependencies for testing
///Call this in the setUp() method of your tests

Future<void> setupTestDependencies() async {
  /// Reset GetIt to ensure clean state for each test
  await getIt.reset();

  ///Configure all dependencies
  await configureDependencies();
}

/// Tears down dependencies after testing
/// Call this in the tearDown() method of your tests
Future<void> tearDownTestDependencies() async {
  await getIt.reset();
}
