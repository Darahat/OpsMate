import 'package:injectable/injectable.dart';

abstract class TestService {
  String getTestMessage();
}

@Injectable(as: TestService)
class TestServiceImpl implements TestService {
  @override
  String getTestMessage() => "Dependency injection is working!";
}
