String getWeekdayString(int weekday) {
  switch (weekday) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return '';
  }
}

String formatDateTimeToDateString(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  final targetDate = DateTime(date.year, date.month, date.day);
  
  if (targetDate == today) {
    return 'Today';
  } else if (targetDate == tomorrow) {
    return 'Tomorrow';
  } else {
    return date.toString().split(' ')[0];
  }
}

String formatDateTimeToTimeString(DateTime date) {
  final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
  return '$hour:${date.minute.toString().padLeft(2, '0')} ${date.hour < 12 ? 'AM' : 'PM'}';
}

String formatPriceInCurrency(double price, String currencyCode) {
  switch (currencyCode) {
    case 'HKD':
      return '$currencyCode ${price.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (Match m) => '${m[1]},')}';
    case 'KRW':
      return '₩${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (Match m) => '${m[1]},')}';
    default:
      return '$currencyCode ${price.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (Match m) => '${m[1]},')}';
  }
}

extension CollectionExtension<T> on Iterable<T> {
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final Map<K, List<T>> result = {};
    
    for (final element in this) {
      final key = keySelector(element);
      result.putIfAbsent(key, () => []).add(element);
    }
    
    return result;
  }
}
