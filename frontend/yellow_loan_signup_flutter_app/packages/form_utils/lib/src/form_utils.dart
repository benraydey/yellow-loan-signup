import 'package:age_calculator/age_calculator.dart';
import 'package:intl/intl.dart';

/// {@template form_utils}
/// Utility functions for user forms
/// {@endtemplate}
class FormUtils {
  /// {@macro form_utils}
  const FormUtils();

  /// Calculates the age in years from the provided ID number assuming the age
  /// is less than 100 years.
  static int ageFromIdNumber(String id) {
    try {
      final dateOfBirth = tryParseDateOfBirthFromIdNumber(id);
      if (dateOfBirth == null) {
        return -1;
      }
      return AgeCalculator.age(dateOfBirth).years;
    } catch (e) {
      return -1;
    }
  }

  /// Calculates the date of birth from the provided ID number assuming the age
  /// is less than 100 years.
  static DateTime? tryParseDateOfBirthFromIdNumber(String id) {
    final dateFormat = DateFormat('yyyy/MM/dd');
    final dateText = id.substring(0, 6);
    final dateTextWithSlashes =
        '${dateText.substring(0, 2)}/${dateText.substring(2, 4)}/${dateText.substring(4, 6)}';
    final currentCentury = DateTime.now().year ~/ 100;
    final prevCentury = currentCentury - 1;
    final DateTime dateOfBirth;
    final DateTime date;
    try {
      date = dateFormat.parseStrict('$currentCentury$dateTextWithSlashes');
    } catch (_) {
      return null;
    }

    if (date.isBefore(DateTime.now())) {
      dateOfBirth = dateFormat.parse('$currentCentury$dateTextWithSlashes');
    } else {
      dateOfBirth = dateFormat.parse('$prevCentury$dateTextWithSlashes');
    }
    return dateOfBirth;
  }
}
