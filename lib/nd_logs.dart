library nd_logs;

import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:nd_logs/src/text_logging/text_logger.dart';
import 'package:path_provider/path_provider.dart';

part "src/logger.dart";

class NDLogs {
  static final _logger = _NDLogger();
  static Future<void> setupLogger() async {
    await _logger.initialiseLogger();
  }

  static Future<void> logThis(String text) async {
    await _logger.recordLog(text);
  }

  /// returns the log file path
  static Future<String> exportLogFile() async {
    await _logger.performExportOperations();
    return await _logger.getLogFilePath();
  }

  static Future<void> clearLogs() async {
    await _logger.clearLogs();
  }
}
