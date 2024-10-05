// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:developer';

import 'package:nd_logs/base/log_types.dart';
import 'package:nd_logs/base/log_writer.dart';
import 'package:nd_logs/src/text_logging/html_modifier.dart';
import 'dart:html' as html;

class WebLogger implements LogWriter {
  final List<String> logs = List<String>.empty(growable: true);

  @override
  Future<void> closeLogFile(bool recordHTML) async {
    if (recordHTML) {
      logs.add(HTMLModifier.htmlFileFooters);
    }

    String content = logs.join('\n');
    final blob = html.Blob([content], 'text/${recordHTML ? "html" : "plain"}');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', "logs.${recordHTML ? "html" : "txt"}")
      ..click(); // Simulate a click to trigger the download
    html.Url.revokeObjectUrl(url);
  }

  @override
  Future<void> deleteLogFile(String filePath) async {
    logs.clear();
  }

  @override
  Future<void> openLogFile(String filePath) async {
    if (filePath.split('.').contains('html')) {
      logs.add(HTMLModifier.htmlFileHeaders);
    }
  }

  @override
  Future<void> writeToLogFile({
    required String logFilePath,
    required bool recordHTML,
    required bool exported,
    required String text,
    required String timestamp,
    required LogType logType,
    required Map<String, String> logData,
  }) async {
    final textLog = "$timestamp ${logType.name} $text ${logData.toString()}";
    if (exported) {
      logs.add(HTMLModifier.htmlFileHeaders);
    }
    logs.add(
      recordHTML
          ? HTMLModifier.convertMapToDiv(
              timestamp: timestamp,
              text: text,
              logData: logData,
              logType: logType,
            )
          : textLog,
    );
    log("NDLogs::$textLog");
  }
}
