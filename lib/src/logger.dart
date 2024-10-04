part of "../nd_logs.dart";

class _NDLogger {
  final receivePort = ReceivePort();
  SendPort? _sendPort;

  Future<void> initialiseLogger() async {
    final logFilePath = await getLogFilePath();
    await Isolate.spawn(_isolateMethod, [receivePort.sendPort, logFilePath]);
    _sendPort = (await receivePort.first) as SendPort;
    debugPrint("NDLogs::initialised.\nLog file at $logFilePath");
  }

  Future<String> getLogFilePath() async {
    final directoryPath = (await getApplicationDocumentsDirectory()).path;
    return "$directoryPath/Logs/log.txt";
  }

  Future<void> recordLog(String text) async {
    if (_sendPort == null) {
      debugPrint("Unable to setup NDLogger");
      return;
    }
    _sendPort?.send(text);
  }

  Future<void> performExportOperations() async {
    _sendPort?.send("export_logs");
  }

  Future<void> clearLogs() async {
    _sendPort?.send("clear_logs");
  }

  /// Isolate methods cannot be async but are required to be
  /// Top-level or static methods.
  static void _isolateMethod(List<dynamic> args) {
    final port = ReceivePort();
    (args[0] as SendPort).send(port.sendPort);
    final logFilePath = args[1] as String;
    TextLogger logger = TextLogger();
    logger.openLogFile(logFilePath).then((_) {
      port.listen((message) async {
        if (message == "export_logs") {
          await logger.closeLogFile();
        } else if (message == "clear_logs") {
          await logger.deleteLogFile(logFilePath);
          await logger.openLogFile(logFilePath);
        } else {
          debugPrint("NDLogs::$message");
          logger.writeToLogFile(
            logFilePath,
            {
              "timestamp": DateTime.now().toIso8601String(),
              "text": message,
            },
          );
        }
      });
    });
  }
}
