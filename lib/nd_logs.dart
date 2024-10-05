/// A simple Logging solution built purely in dart.
/// Supports Android, iOS and Web apps.
library nd_logs;

import 'dart:developer';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:nd_logs/base/log_types.dart';
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

  /// - [text] is what the statement log file will record.
  /// - [paramsTracking] are the app params you wish to track against any event.
  /// This may include tracking user id's, user location as it changes, and any
  /// other data as desired.
  static Future<void> logThis(
    String text, {
    LogType logType = LogType.verbose,
    Map<String, String>? paramsTracking,
  }) async {
    await _logger.recordLog(
      text,
      _recordingHTML,
      _exported,
      paramsTracking ?? {},
      _dateFormat!,
      logType,
    );
    _exported = false;
  }

  static Future<void> logErrorWithStacktrace(
    Object error,
    StackTrace trace, {
    Map<String, String>? paramsTracking,
  }) async {
    await _logger.recordLog(
      "${error.toString()}  \n${trace.toString()}",
      _recordingHTML,
      _exported,
      paramsTracking ?? {},
      _dateFormat!,
      LogType.exception,
    );
  }

  /// returns the log file path.
  ///
  /// For Web, returns an empty string and starts a log file download.
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
