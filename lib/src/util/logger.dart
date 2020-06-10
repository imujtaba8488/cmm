class Log {
  static i(String where, String what) {
    print(':: $where :: ' '~~ $what ~~');

    // String stackTrace = StackTrace.current.toString();
  }
}
