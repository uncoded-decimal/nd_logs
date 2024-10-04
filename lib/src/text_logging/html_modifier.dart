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
  }) {
    return '''
<div>    
    <table>
        <tr style="background-color: #f2f2f2;">
            <td style="flex-grow: 1;">$timestamp</td>
            <td style="flex-grow: 7;">$text</td>
            <td style="flex-grow: 2;">
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
