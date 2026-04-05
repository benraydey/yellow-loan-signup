import 'package:equatable/equatable.dart';
import 'package:formy/src/models/auto_validate_rules.dart';
import 'package:formy/src/models/types.dart';
import 'package:formy/src/models/validation_state.dart';

/// State object that holds the state of a field.
class FormyFieldState<T> extends Equatable {
  /// Creates a [FormyFieldState] object.
  const FormyFieldState({
    required this.name,
    required this.label,
    // required this.order,
    required this.autoValidateRules,
    this.validationStateSaved = ValidationState.neutral,
    this.isFocused = false,
    this.value,
    this.hasBeenUnfocused = false,
    this.hasBeenForceValidated = false,
    this.validator,
    this.error,
  });

  /// Name that uniquely identifies this field
  final String name;

  /// Label to display to user.
  final String label;

  /// Order of field in the form.
  ///
  /// Determined by the order in which this field is first registered compared
  /// to other fields the form.
  // final int order;

  /// Current value of field
  final T? value;

  /// Specifies the validity of the field.
  final ValidationState validationStateSaved;

  /// Whether the field is currently focused.
  final bool isFocused;

  /// Whether the field has been unfocused for the first time yet.
  final bool hasBeenUnfocused;

  /// Whether the field has been force validated for the first time yet.
  final bool hasBeenForceValidated;

  /// Specifies when the field can be auto validated.
  final AutoValidateRules? autoValidateRules;

  /// Function returning null if the field is valid otherwise an error message
  /// String.
  final ValidatorFunction<T?>? validator;

  /// Error message to display to user if field is invalid.
  ///
  /// [error] cannot be null if [validationStateSaved] is
  /// [ValidationState.invalid].
  final String? error;

  /// Whether the field is shown as valid to the user.
  ///
  /// I.e. whether it was considered valid when it was most recently
  /// validated, either auto validated or force validated.
  bool get isValidSaved => validationStateSaved == ValidationState.valid;

  /// Whether the field is valid at this moment.
  bool get isValidInstant => errorInstant == null;

  /// Error message explaining why the field is invalid or null indicating that
  /// the field is valid.
  String? get errorInstant => validator?.call(value, label);

  /// Returns a copy of this object after being validated.
  FormyFieldState<T> get validated {
    return copyWith(
      validationStateSaved:
          isValidInstant ? ValidationState.valid : ValidationState.invalid,
      error: errorInstant,
      updateError: true,
      hasBeenForceValidated: true,
    );
  }

  /// Returns a copy of this object with validation state set to neutral.
  FormyFieldState<T> get neutralised {
    return copyWith(
      validationStateSaved: ValidationState.neutral,
      error: null,
      updateError: true,
    );
  }

  /// Whether this field should be auto validated
  ///
  /// [otherFieldChanged] specifies whether it was another field that changed (
  /// i.e. not this field)
  bool shouldAutoValidate({required bool otherFieldChanged}) {
    if (autoValidateRules == null) {
      return false;
    }
    if (otherFieldChanged && autoValidateRules!.listenToOtherFields) {
      return false;
    }
    if (!autoValidateRules!.enabled) {
      return false;
    }
    if (isFocused &&
        autoValidateRules!.ifFocused == AutoValidateIfFocused.ignore) {
      return false;
    }
    switch (autoValidateRules!.waitFor) {
      case AutoValidateWaitFor.firstUnfocus:
        return hasBeenUnfocused;
      case AutoValidateWaitFor.firstForcedValidation:
        return hasBeenForceValidated;
      case AutoValidateWaitFor.firstUnfocusOrForcedValidation:
        return hasBeenUnfocused || hasBeenForceValidated;
    }
  }

  /// Returns an auto validated copy of this object.
  FormyFieldState<T> maybeAutoValidated({required bool otherFieldChanged}) {
    return shouldAutoValidate(otherFieldChanged: otherFieldChanged)
        ? autoValidated
        : this;
  }

  /// Returns a copy of this object that has been either neutralised if
  /// [autoValidateRules] allows or validated.
  FormyFieldState<T> get autoValidated {
    if (isFocused &&
        autoValidateRules!.ifFocused ==
            AutoValidateIfFocused.neutralAfterValueChanged) {
      return neutralised;
    } else {
      return validated;
    }
  }

  /// Returns a copy of this object reset to initial values
  FormyFieldState<T> get reset {
    return copyWith(
      updateValue: true,
      hasBeenUnfocused: false,
      hasBeenForceValidated: false,
      validationStateSaved: ValidationState.neutral,
      updateError: true,
    );
  }

  /// Returns a copy of this object with the given overrides.
  ///
  /// Note that [value], [validator], and [error] will only be updated
  /// if their respective update flags, [updateValue], [updateValidator] and
  /// [updateError] are set to true. This requirement is necessary to allow
  /// them to be set to null values.
  FormyFieldState<T> copyWith({
    String? name,
    String? label,
    T? value,
    bool updateValue = false,
    ValidationState? validationStateSaved,
    bool? isFocused,
    bool? hasBeenUnfocused,
    bool? hasBeenForceValidated,
    AutoValidateRules? autoValidateRules,
    ValidatorFunction<T?>? validator,
    bool updateValidator = false,
    String? error,
    bool updateError = false,
  }) {
    return FormyFieldState<T>(
      name: name ?? this.name,
      label: label ?? this.label,
      value: updateValue ? value : this.value,
      validationStateSaved: validationStateSaved ?? this.validationStateSaved,
      isFocused: isFocused ?? this.isFocused,
      hasBeenUnfocused: hasBeenUnfocused ?? this.hasBeenUnfocused,
      hasBeenForceValidated:
          hasBeenForceValidated ?? this.hasBeenForceValidated,
      autoValidateRules: autoValidateRules ?? this.autoValidateRules,
      validator: updateValidator ? validator : this.validator,
      error: updateError ? error : this.error,
    );
  }

  @override
  List<Object?> get props => [
        name,
        label,
        autoValidateRules,
        validationStateSaved,
        isFocused,
        value,
        hasBeenUnfocused,
        hasBeenForceValidated,
        validator,
        error,
      ];
}
