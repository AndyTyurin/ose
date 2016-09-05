part of ose_utils;

/// Generate universal unique identifier.
String generateUuid() {
  var d = new DateTime.now().millisecond;
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replaceAllMapped(
      new RegExp(r'[xy]'),
      (Match c) {
        var r = ((d + new Random().nextDouble()*16)%16).toInt() | 0;
        d = (d / 16).floor();
        return (c.toString()=='x' ? r : (r&0x3|0x8)).toRadixString(16);
      }
  );
}

abstract class UuidMixin {
  final String uuid = generateUuid();
}
