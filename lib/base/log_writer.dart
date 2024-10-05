import 'package:nd_logs/base/log_types.dart';

abstract class LogWriter {
  Future<void> openLogFile(String filePath);
  Future<void> writeToLogFile({
    required String logFilePath,
    required bool recordHTML,
    required bool exported,
    required String text,
    required String timestamp,
    required Map<String, String> logData,
    required LogType logType,
  });
  Future<void> closeLogFile(bool recordHTML);
  Future<void> deleteLogFile(String filePath);
}
