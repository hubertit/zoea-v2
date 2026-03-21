import 'package:intl/intl.dart';

class PriceFormatter {
  static String formatAbbreviated(double price, {String currency = 'RWF'}) {
    if (price >= 1000000) {
      final millions = price / 1000000;
      final formatted = millions % 1 == 0 
          ? millions.toStringAsFixed(0) 
          : millions.toStringAsFixed(1);
      return '$formatted${currency.isNotEmpty ? 'M $currency' : 'M'}';
    } else if (price >= 1000) {
      final thousands = price / 1000;
      final formatted = thousands % 1 == 0 
          ? thousands.toStringAsFixed(0) 
          : thousands.toStringAsFixed(1);
      return '$formatted${currency.isNotEmpty ? 'k $currency' : 'k'}';
    }
    return '${price.toStringAsFixed(0)}${currency.isNotEmpty ? ' $currency' : ''}';
  }

  static String formatAbbreviatedRange(
    double minPrice, 
    double maxPrice, {
    String currency = 'RWF',
  }) {
    if (minPrice == maxPrice) {
      return formatAbbreviated(minPrice, currency: currency);
    }
    
    final formattedMin = formatAbbreviated(minPrice, currency: '');
    final formattedMax = formatAbbreviated(maxPrice, currency: '');
    
    return '$formattedMin - $formattedMax${currency.isNotEmpty ? ' $currency' : ''}';
  }

  static String formatFull(double price, {String currency = 'RWF'}) {
    final formatter = NumberFormat('#,##0', 'en_US');
    final formatted = formatter.format(price);
    return '${currency.isNotEmpty ? '$currency ' : ''}$formatted';
  }

  static String formatFullRange(
    double minPrice, 
    double maxPrice, {
    String currency = 'RWF',
  }) {
    if (minPrice == maxPrice) {
      return formatFull(minPrice, currency: currency);
    }
    
    final formatter = NumberFormat('#,##0', 'en_US');
    final formattedMin = formatter.format(minPrice);
    final formattedMax = formatter.format(maxPrice);
    
    return '${currency.isNotEmpty ? '$currency ' : ''}$formattedMin - $formattedMax';
  }
}
