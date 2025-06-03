import 'package:flutter/material.dart';
import 'package:opsmate/app/theme/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:opsmate/injection_container.dart';

Future<void> main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

/// The root widget of the OpsMate application.
///
/// This widget sets up the application's theme and entry point.
/// It uses [MaterialApp] to initialize the app with both light and dark themes.
class MyApp extends StatelessWidget {
  /// Creates an instance of [MyApp].

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpsMate',
      theme: lightTheme,
      darkTheme:
          darkTheme, // Make sure you have a darkTheme defined in theme_config.dart
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

/// The main page of the OpsMate application.
///
/// Displays the primary user interface after the app has started.
/// This page is stateful and can respond to user interactions or state changes.
class MyHomePage extends StatefulWidget {
  /// Creates an instance of [MyHomePage].
  ///
  /// The [title] is displayed in the app bar or used as a label.
  const MyHomePage({super.key, required this.title});

  /// The title displayed on the home page.

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pressed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
