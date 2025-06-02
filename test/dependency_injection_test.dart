import 'package:flutter_test/flutter_test.dart';
import 'package:opsmate/injection_container.dart';
import 'package:opsmate/core/utils/test_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    configureDependencies();
  });

  test('TestService should be registered', () {
    print('Test is running'); // Debug output
    final testService = getIt<TestService>();
    print('Retrieved service: $testService'); // Debug output
    final message = testService.getTestMessage();
    print('Service returned: $message');
    expect(testService, isA<TestServiceImpl>());
  });

  test('TestService should return correct message', () {
    final testService = getIt<TestService>();
    expect(testService.getTestMessage(), 'Dependency injection is working!');
  });
}
