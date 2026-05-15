class DelayHelper {
  static Future<void> wait([int seconds = 5]) async {
    await Future.delayed(Duration(seconds: seconds));
  }
}

class AppDelay {
  static const short = 2;
  static const medium = 4;
  static const long = 5;
}