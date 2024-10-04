library nd_logs;

import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:nd_logs/base/log_writer.dart';
import 'package:nd_logs/src/text_logging/text_logger.dart';
import 'package:nd_logs/src/web_logging/web_logger.dart';
import 'package:path_provider/path_provider.dart';

part "src/logger.dart";

class NDLogs {
  static final _logger = _NDLogger();
  static bool _recordingHTML = false;
  static bool _exported = false;
  static DateFormat? _dateFormat;

  bool get isLoggingHTML => _recordingHTML;

  static Future<void> setupLogger({
    bool recordHTML = false,
    DateFormat? dateFormat,
  }) async {
    _recordingHTML = recordHTML;
    _dateFormat = dateFormat ?? DateFormat("dd-MMMM-yyyy hh:mm:ss a");
    await _logger.initialiseLogger(
      recordHTML: recordHTML,
    );
  }

  static Future<void> logThis(
    String text, {
    Map<String, String>? paramsTracking,
  }) async {
    await _logger.recordLog(
      text,
      _recordingHTML,
      _exported,
      paramsTracking ?? {},
      _dateFormat!,
    );
    _exported = false;
  }

  /// returns the log file path
  static Future<String> exportLogFile() async {
    await _logger.performExportOperations(_recordingHTML);
    _exported = true;
    return await _logger.getLogFilePath(
      recordHTML: _recordingHTML,
    );
  }

  static Future<void> clearLogs() async {
    await _logger.clearLogs();
  }
}
