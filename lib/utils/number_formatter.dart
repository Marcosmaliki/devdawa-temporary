import 'package:intl/intl.dart';

extension ReadableNumber on num {
  //Add commas on numbers less than a million, shorten numbers larger than 1M
  String get formatNumber => this < 1000000
      ? NumberFormat("#,###", "en_US").format(this)
      : NumberFormat.compact().format(this);
}
