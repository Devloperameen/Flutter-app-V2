import 'package:logger/logger.dart';

/// Application-wide logger instance using the `logger` package
final log = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
  ),
);

