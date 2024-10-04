library nd_logs;

abstract class LogWriter {
  Future<void> openLogFile(String filePath);
  Future<void> writeToLogFile({
    required String logFilePath,
    required bool recordHTML,
    required String text,
    required String timestamp,
    required Map<String, String> logData,
  });
  Future<void> closeLogFile(bool recordHTML);
  Future<void> deleteLogFile(String filePath);
}
