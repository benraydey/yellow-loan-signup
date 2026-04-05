import 'package:intl/intl.dart';

extension DoubleExtension on double {
  String toRandsString([String divider = '']) {
    return 'R$divider${NumberFormat('#,##,##0').format(this)}';
  }

  String toRandsStringWithDecimals([String divider = '']) {
    final hasCents = this % 1 != 0;

    final format = hasCents ? NumberFormat('#,##0.00') : NumberFormat('#,##0');

    return 'R$divider${format.format(this)}';
  }

  String toRandsStringFixedDecimals([String divider = '']) {
    final format = NumberFormat('#,##0.00');
    return 'R$divider${format.format(this)}';
  }
}
