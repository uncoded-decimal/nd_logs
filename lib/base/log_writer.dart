library nd_logs;

abstract class LogWriter {
  Future<void> openLogFile(String filePath);
  Future<void> writeToLogFile(
    String logFilePath,
    Map<String, String> logData,
  );
  Future<void> closeLogFile();
  Future<void> deleteLogFile(String filePath);
}
