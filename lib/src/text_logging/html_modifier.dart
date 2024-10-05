import 'package:nd_logs/base/log_types.dart';

class HTMLModifier {
  static String get htmlFileHeaders => '''
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>LOGS</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse; /* Collapse borders */
        }
        td {
            border: 1px solid #000; /* Add border to cells */
            padding: 10px; /* Add padding to cells */
            text-align: center; /* Center align text */
        }
    </style>
  </head>
<body>
''';

  static String get htmlFileFooters => '''
</body>
</html>
''';

  static String convertMapToDiv({
    required String timestamp,
    required String text,
    required Map<String, String> logData,
    required LogType logType,
  }) {
    return '''
<div>    
    <table>
        <tr style="background-color: #${logType.htmlLogColour};">
            <td style="width: 10%; text-align: left;">$timestamp</td>
            <td style="width: 10%; text-align: left;">${logType.name}</td>
            <td style="width: 50%; text-align: left;">$text</td>
            <td style="width: 30%; text-align: left;">
              <ul>
              ${logData.entries.map((e) => '''<li>${e.key}: ${e.value}</li>''').join("")}
              </ul>
            </td>
        </tr>
    </table>
</div>
''';
  }
}
