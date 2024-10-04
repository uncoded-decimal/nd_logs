import 'package:flutter_test/flutter_test.dart';

import 'package:nd_logs/nd_logs.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Initialisation Test', () async {
    await NDLogs.setupLogger();
  });
}
