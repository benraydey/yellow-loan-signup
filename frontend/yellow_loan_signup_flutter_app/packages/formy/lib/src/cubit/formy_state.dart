part of 'formy_cubit.dart';

class FormyState extends Equatable {
  const FormyState({
    this.fields = const {},
    this.isValid = false,
    this.autoValidateRules,
    this.nullValidator,
    this.hasEditingStarted = false,
  });

  final FieldsMap fields;
  final bool isValid;

  final AutoValidateRules? autoValidateRules;
  final NullValidatorFunction? nullValidator;

  final bool hasEditingStarted;

  FormyState copyWith({
    FieldsMap? fields,
    bool? isValid,
    AutoValidateRules? autoValidateRules,
    NullValidatorFunction? nullValidator,
    bool? hasEditingStarted,
  }) {
    return FormyState(
      fields: fields ?? this.fields,
      isValid: isValid ?? this.isValid,
      autoValidateRules: autoValidateRules ?? this.autoValidateRules,
      nullValidator: nullValidator ?? this.nullValidator,
      hasEditingStarted: hasEditingStarted ?? this.hasEditingStarted,
    );
  }

  @override
  List<Object?> get props => [
        fields,
        isValid,
        autoValidateRules,
        nullValidator,
        hasEditingStarted,
      ];
}

/// Map of keys to field states.
typedef FieldsMap = Map<String, FormyFieldState<dynamic>>;
