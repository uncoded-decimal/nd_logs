import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nd_logs/base/log_types.dart';
import 'package:nd_logs/nd_logs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NDLogs.setupLogger(recordHTML: true);
  runZonedGuarded(
    () => runApp(const MyApp()),
    (error, stack) async {
      await NDLogs.logErrorWithStacktrace(
        error,
        stack,
        paramsTracking: {
          "name": "Andi",
          "counter": "Unable to comply",
        },
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      NDLogs.logThis(
        "Counter value = $_counter",
        paramsTracking: {
          "name": "Andi",
          "counter": _counter.toString(),
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.import_export),
              onPressed: () => _exportLogs(),
            ),
          ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
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
      ),
    );
  }

  Future<void> _exportLogs() async {
    await NDLogs.logThis(
      "Exporting Logs",
      logType: LogType.warning,
    );
    final path = await NDLogs.exportLogFile();
    debugPrint("File found at $path");
    final content = await File(path).readAsString();
    log(content);
    await NDLogs.clearLogs();
  }
}
