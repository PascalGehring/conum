class DateManager {
  String getDate() {
    final DateTime date = DateTime.now().subtract(Duration(days: 1));

    final String dateStringWithoutZ =
        DateTime(date.year, date.month, date.day).toIso8601String();

    final String dateStringWithZ = '${dateStringWithoutZ}Z';

    return dateStringWithZ;
  }
}
