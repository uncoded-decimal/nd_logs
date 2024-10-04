part of "../nd_logs.dart";

class _NDLogger {
  final receivePort = ReceivePort();
  SendPort? _sendPort;

  Future<void> initialiseLogger({
    bool recordHTML = false,
  }) async {
    final logFilePath = await getLogFilePath(recordHTML: recordHTML);
    await Isolate.spawn(_isolateMethod, [receivePort.sendPort, logFilePath]);
    _sendPort = (await receivePort.first) as SendPort;
    debugPrint("NDLogs::initialised.\nLog file at $logFilePath");
  }

  Future<String> getLogFilePath({
    bool recordHTML = false,
  }) async {
    final directoryPath = (await getApplicationDocumentsDirectory()).path;
    return "$directoryPath/Logs/log.${recordHTML ? "html" : "txt"}";
  }

  Future<void> recordLog(
    String text,
    bool recordHTML,
    bool exported,
    Map<String, String> params,
    DateFormat dateFormat,
  ) async {
    if (_sendPort == null) {
      debugPrint("Unable to setup NDLogger");
      return;
    }
    _sendPort?.send([
      text,
      params,
      recordHTML,
      exported,
      dateFormat,
    ]);
  }

  Future<void> performExportOperations(bool recordHTML) async {
    _sendPort?.send(["export_logs", {}, recordHTML]);
  }

  Future<void> clearLogs() async {
    _sendPort?.send(["clear_logs", {}]);
  }

  /// Isolate methods cannot be async but are required to be
  /// Top-level or static methods.
  static void _isolateMethod(List<dynamic> args) {
    final port = ReceivePort();
    (args[0] as SendPort).send(port.sendPort);
    final logFilePath = args[1] as String;
    TextLogger logger = TextLogger();
    logger.openLogFile(logFilePath).then((_) {
      port.listen((data) async {
        final message = data[0];
        if (message == "export_logs") {
          final recordHTML = (data[2] as bool?) ?? false;
          await logger.closeLogFile(recordHTML);
        } else if (message == "clear_logs") {
          await logger.deleteLogFile(logFilePath);
          await logger.openLogFile(logFilePath);
        } else {
          final params = data[1] as Map<String, String>;
          final recordHTML = (data[2] as bool?) ?? false;
          final exported = (data[3] as bool?) ?? false;
          final dateFormat =
              (data[4] as DateFormat?) ?? DateFormat("dd-MMMM-yyyy hh:mm:ss a");
          debugPrint("NDLogs::$message for $params");
          logger.writeToLogFile(
            logFilePath: logFilePath,
            recordHTML: recordHTML,
            logData: params,
            text: message,
            timestamp: dateFormat.format(DateTime.now()),
            exported: exported,
          );
        }
      });
    });
  }
}
