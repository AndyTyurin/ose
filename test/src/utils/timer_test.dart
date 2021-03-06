@TestOn('content-shell')

import 'package:test/test.dart';
import 'package:ose/ose_utils.dart' show Timer;

void main() {
  group('Timer', () {
    Timer timer = new Timer();
    timer.init();
    num t0 = timer.delta;

    test('#delta Delta time is difference of current and previous times', () {
      num t1 = new DateTime.now().millisecondsSinceEpoch;
      timer.checkpoint(t1);
      expect(timer.delta, t1 - t0);
    });
  });
}
