import 'dart:html';

import 'package:logging/logging.dart';

void initLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    Level level = rec.level;
    // Colorize & set state for logging.
    if (level == Level.INFO) {
      window.console.log('${rec.level.name}: ${rec.time}: ${rec.message}');
    } else if (level == Level.SEVERE) {
      window.console.error('${rec.level.name}: ${rec.time}: ${rec.message}');
    } else if (level == Level.WARNING || level == Level.SHOUT) {
      window.console.warn('${rec.level.name}: ${rec.time}: ${rec.message}');
    } else {
      window.console.debug('${rec.level.name}: ${rec.time}: ${rec.message}');
    }
  });
}
