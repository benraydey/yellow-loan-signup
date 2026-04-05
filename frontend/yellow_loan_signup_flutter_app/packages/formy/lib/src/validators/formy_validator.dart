import 'package:formy/src/models/types.dart';

/// Collection of formy validators of various types
class FormyValidator {
  /// Takes in a list of validators and returns a validator that returns the
  /// first error message from the list of validators
  static ValidatorFunction<T> builder<T>(
    List<ValidatorFunction<T>> validators,
  ) {
    return (T value, String label) {
      for (final validator in validators) {
        final error = validator(value, label);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }

  /// Field is required
  static NullValidatorFunction required() {
    return (dynamic value, String label) {
      if (value == null) {
        return '$label is required';
      }
      return null;
    };
  }

  /// Field is not required and can be empty
  static NullValidatorFunction optional() {
    return (dynamic value, String label) => null;
  }
}
