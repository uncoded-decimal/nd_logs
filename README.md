# nd_logs

A logging solution for Flutter/Dart apps built purely in Dart.

## Getting Started

Add this code to begin:

```dart
  WidgetsFlutterBinding.ensureInitialized();
  await NDLogs.setupLogger();
```

You can start adding logs by simply calling:

```dart
NDLogs.logThis("My first log!");
```

To export logs,

```dart
final logFilePath = await NDLogs.exportLogFile();
```

To clear logs,

```dart
await NDLogs.clearLogs();
```
