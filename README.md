# nd_logs

A logging solution for Flutter/Dart apps built purely in Dart.

Note that this is currently only tested for support on Android and iOS. Basic Web support has also been added. However, since web apps do not have access to the file-system as native apps do, **the logging for web is session based and it is saved to Downloads only on the call of the export method**.

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

## Future Plans

- Add more detailed log support for various Log Types
- Add better ui to HTML log file

Feel free to suggest/ request features as you may desire. However, I'll work on them as I get to them.
