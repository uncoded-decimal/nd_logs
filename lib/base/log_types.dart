import 'dart:ui';

enum LogType {
  /// Log type to use for regular logging.
  verbose,

  /// Log type to use for logging of
  /// certain key points.
  info,

  /// Log type to use for logging non-fatal errors.
  warning,

  /// Log type for Errors.
  exception,
}

extension LoggingUtils on LogType {
  String get name => switch (this) {
        LogType.verbose => "VERBOSE",
        LogType.info => "INFO",
        LogType.warning => "WARNING",
        LogType.exception => "EXCEPTION",
      };
  String get htmlLogColour => switch (this) {
        LogType.verbose => "f2f2f2",
        LogType.info => "7ed5f2",
        LogType.warning => "f2e47e",
        LogType.exception => "ed9d9d",
      };
  Color get logColour => switch (this) {
        LogType.verbose => const Color(0xfff2f2f2),
        LogType.info => const Color(0xff7ed5f2),
        LogType.warning => const Color(0xfff2e47e),
        LogType.exception => const Color(0xffed9d9d),
      };
}
