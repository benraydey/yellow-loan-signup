import 'package:form_utils/form_utils.dart';
import 'package:formy/src/models/types.dart';
import 'package:formy/src/utils/string_extensions.dart';
import 'package:intl/intl.dart';

/// Formy String validators
class FormyStringValidator {
  static String _notAValid(String label) {
    final cleaned = label.toLowerCase().replaceAll('enter a', '').trim();

    return 'Not a valid $cleaned';
  }

  static final _nameRegex = RegExp(r"^[a-zA-Z ',.-]+$");

  /// String is a valid name, having only letters, spaces, and the following
  /// characters (excluding the square brackets): [' , . -]
  static ValidatorFunction<String> name() {
    return FormyStringValidator._name;
  }

  static String? _name(String value, String label) {
    if (!_nameRegex.hasMatch(value)) {
      return 'Only letters, periods and hyphens allowed';
    }
    return null;
  }

  /// String is a valid email address
  static ValidatorFunction<String> email() {
    return FormyStringValidator._email;
  }

  static String? _email(String value, String label) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Not a valid ${label.toLowerCaseExceptUppercase()}';
    }
    return null;
  }

  /// String is a valid South African phone number
  static ValidatorFunction<String> phoneNumber() {
    return FormyStringValidator.phoneNumberValidator;
  }

  /// Validates that the string is a valid South African phone number, starting
  /// with 0 or 27, and containing at least 2 different digits in
  /// the national number portion
  static String? phoneNumberValidator(String number, String label) {
    // Only allow numbers starting with 0XXXXXXXXX or 27XXXXXXXXX
    final saMobileRegExp = RegExp(r'^(0\d{9}|27\d{9})$');

    // First ensure the overall structure is correct
    if (!saMobileRegExp.hasMatch(number)) {
      return _notAValid(label);
    }
    // Ensure at least 2 different digits in the national number
    // (subscriber part)
    final nationalNumber =
        number.startsWith('27') ? number.substring(2) : number.substring(1);
    if (nationalNumber.split('').toSet().length < 2) {
      return _notAValid(label);
    }
    return null;
  }

  /// String is a valid data bundle selection (i.e., not the initial value)
  static ValidatorFunction<String> dataBundleSelector(String initialValue) {
    return (value, label) =>
        FormyStringValidator._dataBundleSelector(value, label, initialValue);
  }

  static String? _dataBundleSelector(
      String value, String label, String initialValue) {
    if (value == initialValue) {
      return 'Please select a data bundle';
    }

    return null;
  }

  /// String is at least [minLength] characters long
  static ValidatorFunction<String> minLength(int minLength) {
    return (value, label) =>
        FormyStringValidator._minLength(value, label, minLength);
  }

  static String? _minLength(String value, String label, int minLength) {
    if (value.length < minLength) {
      return '$label must be at least $minLength characters';
    }
    return null;
  }

  /// String is at most [maxLength] characters long
  static ValidatorFunction<String> maxLength(int maxLength) {
    return (value, label) =>
        FormyStringValidator._maxLength(value, label, maxLength);
  }

  static String? _maxLength(String value, String label, int maxLength) {
    if (value.length > maxLength) {
      return '$label must be at most $maxLength characters';
    }
    return null;
  }

  /// String is between [minLength] and [maxLength] characters long
  static ValidatorFunction<String> length(int minLength, int maxLength) {
    return (value, label) =>
        FormyStringValidator._length(value, label, minLength, maxLength);
  }

  static String? _length(
    String value,
    String label,
    int minLength,
    int maxLength,
  ) {
    if (minLength == maxLength && value.length != minLength) {
      return '$label must be $minLength characters long';
    }
    if (value.length < minLength || value.length > maxLength) {
      return '$label must be between $minLength and $maxLength characters long';
    }
    return null;
  }

  /// String is a number
  static ValidatorFunction<String> number() {
    return FormyStringValidator._number;
  }

  static String? _number(String value, String label) {
    final regExp = RegExp(r'^[0-9]+$');
    if (!regExp.hasMatch(value)) {
      return '$label must be a number';
    }
    return null;
  }

  /// String is a valid South African ID number
  ///
  /// if [minAge] is provided, the ID number must be of someone at least
  /// [minAge] years old.
  ///
  /// if [maxAge] is provided, the ID number must be of someone at most
  /// [maxAge] years old.
  static ValidatorFunction<String> idNumber({
    int? minAge,
    int? maxAge,
  }) {
    return (value, label) =>
        FormyStringValidator._idNumber(value, label, minAge, maxAge);
  }

  static String? _idNumber(
      String value, String label, int? minAge, int? maxAge) {
    final regExpNumbers = RegExp(r'^[0-9]+$');
    if (!regExpNumbers.hasMatch(value)) {
      return 'Only numbers allowed';
    }
    if (value.length != 13) {
      return '${label.toLowerCaseExceptUppercase()} must be 13 digits long';
    }
    // apply Luhn formula for check-digits
    var tempTotal = 0;
    var checkSum = 0;
    var multiplier = 1;
    for (var i = 0; i < 13; ++i) {
      tempTotal = int.parse(value[i]) * multiplier;
      if (tempTotal > 9) {
        tempTotal = int.parse(tempTotal.toString()[0]) +
            int.parse(tempTotal.toString()[1]);
      }
      checkSum = checkSum + tempTotal;
      multiplier = multiplier.isEven ? 1 : 2;
    }
    if ((checkSum % 10) != 0) {
      return 'Not a valid ${label.toLowerCaseExceptUppercase()}';
    }

    // Validate that the date part of the id is a valid date
    final age = FormUtils.ageFromIdNumber(value);
    if (age == -1) {
      return 'Date in ${label.toLowerCaseExceptUppercase()} is '
          'not a valid date';
    }
    // If minAge and/or maxAge is provided, validate the age
    if (minAge != null && maxAge != null) {
      if (age < minAge || age > maxAge) {
        return 'You must be between $minAge and $maxAge years of age';
      }
    } else if (minAge != null) {
      if (age < minAge) {
        return 'You must be at least $minAge years of age';
      }
    } else if (maxAge != null) {
      if (age > maxAge) {
        return 'You must be at most $maxAge years of age';
      }
    }

    return null;
  }

  /// String is a valid asylum and passport number
  static ValidatorFunction<String> asylumAndNonSAPassportNumber() {
    return FormyStringValidator._asylumAndNonSAPassportNumber;
  }

  static String? _asylumAndNonSAPassportNumber(String value, String label) {
    final hasAlphaNumericalValues = RegExp(r'^[A-Za-z0-9]+$');
    final hasOnlyAlphabetValues = RegExp(r'^[A-Za-z]+$');

    label = '${label[0].toUpperCase()}${label.substring(1).toLowerCase()}';

    if (!hasAlphaNumericalValues.hasMatch(value)) {
      return "${label} can't contain special characters";
    }

    if (value.length < 7) {
      return '${label} must be at least 7 characters';
    }

    if (hasOnlyAlphabetValues.hasMatch(value)) {
      return '${label} must contain digits';
    }

    return null;
  }

  /// String is a valid South African passport number
  static ValidatorFunction<String> saPassportNumber() {
    return FormyStringValidator._saPassportNumber;
  }

  static String? _saPassportNumber(String value, String label) {
    final hasAlphaNumericalValues = RegExp(r'^[A-Za-z0-9]+$');
    final hasOnlyAlphabetValues = RegExp(r'^[A-Za-z]+$');

    if (!hasAlphaNumericalValues.hasMatch(value)) {
      return "Passport number can't contain special characters";
    }

    if (value.length != 9) {
      return 'SA Passport number must be 9 characters';
    }

    if (hasOnlyAlphabetValues.hasMatch(value)) {
      return 'Passport number must contain digits';
    }

    return null;
  }

  /// String is a valid Bill Payments Account number
  static ValidatorFunction<String> billPaymentsAccountNumber({
    required String error,
  }) {
    return (String value, String label) =>
        _billPaymentsAccountNumber(value, label, error);
  }

  static String? _billPaymentsAccountNumber(
      String value, String label, String error) {
    if (error.isNotEmpty) return error;

    final numericRegExp = RegExp(r'^\d+$');
    if (!numericRegExp.hasMatch(value)) {
      return 'Account number should only contain digits';
    }

    return null;
  }

  /// String is a valid Meter number
  static ValidatorFunction<String> meterNumber() {
    return (String value, String label) => meterNumberValidator(value, label);
  }

  static String? meterNumberValidator(String value, String label) {
    // Digits only
    final numericRegExp = RegExp(r'^\d+$');
    if (!numericRegExp.hasMatch(value)) {
      return '$label should contain digits only';
    }

    // Common SA meter lengths (STS)
    if (value.length < 10) {
      return '$label that is at least 10 digits long';
    }

    // Reject obvious invalid numbers
    if (RegExp(r'^0+$').hasMatch(value)) {
      return 'Not a valid ${label.toLowerCaseExceptUppercase()}';
    }

    return null;
  }

  /// String is a valid payment amount, with up to 2 decimal places,
  /// and between min and max
  static ValidatorFunction<String> paymentAmount({
    required double min,
    required double max,
  }) {
    return (String value, String label) =>
        paymentAmountValidator(value, label, min, max);
  }

  static String? paymentAmountValidator(
    String value,
    String label,
    double min,
    double max,
  ) {
    const errorMessage = 'The amount';

    final numerical = RegExp(r'^-?\d+([,.]\d{1,2})?$');

    if (!numerical.hasMatch(value)) {
      return '$errorMessage can only contain valid numerical values '
          '(e.g., 12.34)';
    }

    final amount = double.tryParse(value.replaceAll(',', '.'));

    if (amount == null) {
      return 'Please enter a valid amount';
    }

    if (amount < min || amount > max) {
      return '$errorMessage must be between R${min.toStringAsFixed(2)} - '
          'R${max.toStringAsFixed(2)}';
    }

    return null;
  }

  /// String is a valid beneficiary name (max 50 chars; letters, digits, spaces, apostrophes and hyphens only)
  static ValidatorFunction<String> beneficiaryName() {
    return FormyStringValidator._beneficiaryName;
  }

  static String? _beneficiaryName(String value, String label) {
    if (value.length > 50) {
      return 'The name can be at most 50 characters long';
    }

    // Allows letters (including accented), digits, spaces, apostrophe and hyphen
    final validNameRegex = RegExp(r"^[a-zA-ZÀ-ÿ0-9\s'-]+$");

    if (!validNameRegex.hasMatch(value)) {
      return 'The name may not contain any special characters';
    }

    return null;
  }

  /// String is a valid South African postal code
  static ValidatorFunction<String> postalCode() {
    return FormyStringValidator._postalCode;
  }

  static String? _postalCode(String value, String label) {
    final regExp = RegExp(r'^\d{4}$');
    if (!regExp.hasMatch(value)) {
      return '$label should be 4 digits';
    }
    if (value == '0000') {
      return 'Not a valid ${label.toLowerCaseExceptUppercase()}';
    }
    return null;
  }

  /// String is a valid date of given format
  static ValidatorFunction<String> date({
    String? format,
    int? minAge,
    int? maxAge,
    bool? mustBeFuture,
  }) {
    return (value, label) => FormyStringValidator._date(
        value, label, format, minAge, maxAge, mustBeFuture);
  }

  static String? _date(
    String value,
    String label,
    String? format,
    int? minAge,
    int? maxAge,
    bool? mustBeFuture,
  ) {
    late DateTime dateToValidate;
    if (format != null) {
      try {
        dateToValidate = DateFormat(format).parseStrict(value);
      } catch (_) {
        return 'Not a valid date (${format.toUpperCase()})';
      }
    } else {
      final maybeDate = DateTime.tryParse(value);
      if (maybeDate == null) {
        return 'Not a valid date';
      }
      dateToValidate = maybeDate;
    }

    if (mustBeFuture != null && mustBeFuture == true) {
      if (dateToValidate.isBefore(DateTime.now())) {
        return 'You must have a valid Identification Document';
      }
    }

    if (minAge != null && maxAge != null) {
      if (!_isWithinAge(dateToValidate, minAge, maxAge)) {
        return 'You must be between $minAge and $maxAge years of age';
      }
    } else if (minAge != null) {
      if (!_isWithinAge(dateToValidate, minAge, 200)) {
        return 'You must be at least $minAge years of age';
      }
    } else if (maxAge != null) {
      if (!_isWithinAge(dateToValidate, 0, maxAge)) {
        return 'You must be at most $maxAge years of age';
      }
    }

    return null;
  }

  static bool _isWithinAge(DateTime dateOfBirth, int minAge, int maxAge) {
    final currentDate = DateTime.now();
    final minBirthDate =
        DateTime(currentDate.year - minAge, currentDate.month, currentDate.day);
    final maxBirthDate =
        DateTime(currentDate.year - maxAge, currentDate.month, currentDate.day);

    return (dateOfBirth.isBefore(minBirthDate) ||
            dateOfBirth.isAtSameMomentAs(minBirthDate)) &&
        (dateOfBirth.isAfter(maxBirthDate) ||
            dateOfBirth.isAtSameMomentAs(maxBirthDate));
  }

  /// String is alphanumeric
  static ValidatorFunction<String> alphanumeric() {
    return FormyStringValidator._alphanumeric;
  }

  static String? _alphanumeric(String value, String label) {
    final regExp = RegExp(r'^[a-zA-Z0-9]+$');
    if (!regExp.hasMatch(value)) {
      return 'Only letters and numbers allowed';
    }
    return null;
  }

  /// String is a pin of specified length
  static ValidatorFunction<String> pin([int length = 4]) {
    return (value, label) => FormyStringValidator._pin(value, label, length);
  }

  static String? _pin(String value, String label, int length) {
    if (value.length != length) {
      return 'All $length digits are required';
    }
    return null;
  }
}
