import 'package:intl/intl.dart';

String formatCurrencyString(String amount) {
  try {
    double amountDouble = double.parse(amount);
    final oCcy = new NumberFormat("#,###.##", "es_MX");
    String currency = oCcy.format(amountDouble);
    return '\$ $currency';
  } catch (e) {
    return '';
  }
}

String formatCurrency(double amount) {
  final oCcy = new NumberFormat("#,##0.00", "es_MX");
  String currency = oCcy.format(amount);
  return '\$ $currency';
}

