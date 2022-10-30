import 'dart:async';

class Utils {
  static void Function() overridePrint(List interceptedLogs, void Function() testFn) => () {
        interceptedLogs.clear();
        var spec = ZoneSpecification(print: (_, __, ___, String msg) {
          interceptedLogs.add(msg);
        });
        return Zone.current.fork(specification: spec).run<void>(testFn);
      };
}
