import 'package:intl/intl.dart';

class TextFormat {
  static final _formatPattern =
      NumberFormat.currency(locale: 'pt_BR', symbol: r'R$');

  TextFormat._();

  static String formatReal(double value) => _formatPattern.format(value);
}
