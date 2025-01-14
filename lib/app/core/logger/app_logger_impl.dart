
import 'package:logger/logger.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';

class AppLoggerImpl implements AppLogger{
  final _logger = Logger();
  var messages = <String>[];

  
  @override
  void append(message) {
    messages.add(message);
  }

  @override
  void closeAppend() {
    info(messages.join('\n'));
    messages = [];
  }


  @override
  void debug(message, [error, StackTrace? stackTrace]) => _logger.d(message,error: error, stackTrace: stackTrace);

  @override
  void error(message, [error, StackTrace? stackTrace]) => _logger.e(message,error: error, stackTrace: stackTrace);

  @override
  void info(message, [error, StackTrace? stackTrace]) => _logger.i(message,error: error, stackTrace: stackTrace);

  @override
  void warning(message, [error, StackTrace? stackTrace]) => _logger.w(message,error: error, stackTrace: stackTrace);
  
}