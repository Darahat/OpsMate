import 'package:get_it/get_it.dart'; // Imports the GetIt package, which is a simple yet powerful service locator. It allows you to register and retrieve instances of your classes (services) from a central registry.

import 'package:injectable/injectable.dart'; // Imports the Injectable package. Injectable is a code generator that simplifies the process of registering your dependencies with GetIt by using annotations.
import 'injection_container.config.dart'; // This will be generated running  'flutter pub run build_runner build'

final getIt =
    GetIt
        .instance; // Creates a singleton instance of GetIt. This 'getIt' instance is your central service locator; you'll use it to register your dependencies and then retrieve them when needed throughout your application.

@InjectableInit(
  initializerName:
      r'$initGetIt', // Specifies the name of the initialization function that Injectable will generate. By default, it's `$initGetIt`, which is what you see here. The 'r' before the string denotes a raw string, useful for avoiding issues with special characters.
  preferRelativeImports:
      true, // A configuration option for Injectable. When set to `true`, Injectable will try to use relative paths for imports in the generated code, which can be cleaner and more portable.
  asExtension:
      false, // Another configuration for Injectable. When `false`, the generated initialization function (`$initGetIt`) will be a standalone function. If set to `true`, it would be generated as an extension method on GetIt.
)
Future<void> configureDependencies() async {
  await $initGetIt(getIt);
  // Any manual registrations can go here
}
