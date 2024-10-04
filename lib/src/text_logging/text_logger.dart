library nd_logs;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nd_logs/base/log_writer.dart';

class TextLogger extends LogWriter {
  IOSink? _fileSink;
  @override
  Future<void> openLogFile(String filePath) async {
    final file = await File(filePath).create(recursive: true);
    _fileSink = file.openWrite(mode: FileMode.append);
    debugPrint("NDLogs:Log File Opened");
  }

  @override
  Future<void> writeToLogFile(
    String logFilePath,
    Map<String, String> logData,
  ) async {
    if (_fileSink == null) {
      debugPrint("NDLogs::File sink invalid");
      await openLogFile(logFilePath);
      return;
    }
    _fileSink!.writeln(logData);
  }

  @override
  Future<void> closeLogFile() async {
    await _fileSink!.flush();
    await _fileSink!.close();
  }

  @override
  Future<void> deleteLogFile(String filePath) async {
    await File(filePath).delete();
  }
}
