class DateTimeAsString {
  static String dateAsDDMMYY(
    DateTime date, {
    DateTimeSeparator separator = DateTimeSeparator.dash,
  }) {
    return '${_day(date.day)}'
        '${_separator(separator)}'
        '${_month(date.month)}'
        '${_separator(separator)}'
        '${date.year}';
  }

  static String dateAsMMDDYY(
    DateTime date, {
    DateTimeSeparator separator = DateTimeSeparator.dash,
  }) {
    return '${_month(date.month)}'
        '${_separator(separator)}'
        '${_day(date.month)}'
        '${_separator(separator)}'
        '${date.year}';
  }

  // Review: More formats can be added such as YYDDMM etc.

  static String time(DateTime time) =>
      '${time.hour}:${time.minute}:${time.second}';

  static String _separator(DateTimeSeparator dateTimeSeparator) {
    switch (dateTimeSeparator) {
      case DateTimeSeparator.colon:
        return ':';

      case DateTimeSeparator.forward_slash:
        return '/';

      default:
        return '-';
    }
  }

  static String _day(int day) => day <= 9 ? '0$day' : '$day';

  static String _month(int month) => month <= 9 ? '0$month' : '$month';
}

enum DateTimeSeparator {
  dash,
  colon,
  forward_slash,
}
