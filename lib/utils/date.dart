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
