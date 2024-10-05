import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nd_logs/base/log_types.dart';
import 'package:nd_logs/base/log_writer.dart';
import 'package:nd_logs/src/text_logging/html_modifier.dart';

class TextLogger extends LogWriter {
  IOSink? _fileSink;
  @override
  Future<void> openLogFile(String filePath) async {
    final file = File(filePath);
    final logFile = await file.create(recursive: true);
    if (await file.exists()) {
      String fileContent = await file.readAsString();
      fileContent.replaceAll(HTMLModifier.htmlFileFooters, '');
      _fileSink = logFile.openWrite(mode: FileMode.write);
      _fileSink!.write(fileContent);
      await _fileSink!.flush();
      await _fileSink!.close();
      _fileSink = logFile.openWrite(mode: FileMode.append);
    } else {
      _fileSink = logFile.openWrite(mode: FileMode.append);
      _fileSink!.writeln(HTMLModifier.htmlFileHeaders);
    }
    debugPrint("NDLogs:Log File Opened");
  }

  @override
  Future<void> writeToLogFile({
    required String logFilePath,
    required bool recordHTML,
    required String text,
    required String timestamp,
    required Map<String, String> logData,
    required LogType logType,
    bool exported = false,
  }) async {
    if (_fileSink == null) {
      debugPrint("NDLogs::File sink invalid");
      await openLogFile(logFilePath);
      return;
    }
    String log = "$timestamp ${logType.name}  $text  ${logData.toString()}";
    if (recordHTML) {
      log = HTMLModifier.convertMapToDiv(
        timestamp: timestamp,
        text: text,
        logData: logData,
        logType: logType,
      );
      if (exported) {
        _fileSink!.writeln(HTMLModifier.htmlFileHeaders);
      }
    }
    _fileSink!.writeln(log);
  }

  @override
  Future<void> closeLogFile(bool recordHTML) async {
    if (recordHTML) {
      _fileSink!.writeln(HTMLModifier.htmlFileFooters);
    }
  }

  @override
  Future<void> deleteLogFile(String filePath) async {
    await File(filePath).delete();
  }
}
