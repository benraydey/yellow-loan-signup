import 'package:formy/formy.dart';

/// Defines when a field is allowed to be auto validated.
class AutoValidateRules {
  /// Defines when a field is allowed to be auto validated
  ///
  /// [ifFocused] defaults to [AutoValidateIfFocused.neutralAfterValueChanged].
  /// [waitFor] defaults to
  /// [AutoValidateWaitFor.firstUnfocusOrForcedValidation].
  const AutoValidateRules({
    this.enabled = true,
    this.listenToOtherFields = true,
    AutoValidateIfFocused? ifFocused,
    AutoValidateWaitFor? waitFor,
  })  : ifFocused = ifFocused ?? AutoValidateIfFocused.neutralAfterValueChanged,
        waitFor = waitFor ?? AutoValidateWaitFor.firstUnfocusOrForcedValidation;

  /// Returns a [AutoValidateRules] that will result in a field never
  /// being auto validated.
  const factory AutoValidateRules.never() = _AutoValidateRulesNever;

  /// Returns a [AutoValidateRules] that obeys the three inline validation
  /// rules:
  /// 1. No premature validation.
  /// 2. Remove error messages as soon as the input is validated.
  /// 3. Use positive inline validation.
  const factory AutoValidateRules.standard() = _AutoValidateRulesStandard;

  /// Whether to auto validate the field.
  ///
  /// If [enabled] is false, all other parameters of this [AutoValidateRules]
  /// are ignored.
  final bool enabled;

  /// Whether to check validity of a field after user interaction occurs
  /// with other fields in scope.
  ///
  /// Two fields are in the same scope if they share a common nearest
  /// ancestor [Formy] widget.
  ///
  /// If [listenToOtherFields] is false, validity of a field will only
  /// be checked after user interaction with the field itself, notwithstanding
  /// other auto validate rules.
  ///
  /// User interaction is defined as changing the value of a
  /// field or changing the focus of a field.
  final bool listenToOtherFields;

  /// How to auto validate when a field is in focus, notwithstanding other auto
  /// validate rules.
  final AutoValidateIfFocused ifFocused;

  /// Specifies events that must happen before the field is allowed to
  /// auto validate, notwithstanding other rules defined in this
  /// [AutoValidateRules] object.
  final AutoValidateWaitFor waitFor;
}

class _AutoValidateRulesNever extends AutoValidateRules {
  const _AutoValidateRulesNever() : super(enabled: false);
}

class _AutoValidateRulesStandard extends AutoValidateRules {
  const _AutoValidateRulesStandard()
      : super(
          enabled: true,
          listenToOtherFields: true,
          ifFocused: AutoValidateIfFocused.checkAfterValueChanged,
          waitFor: AutoValidateWaitFor.firstUnfocusOrForcedValidation,
        );
}

/// Whether to auto validate when the field is focused.
enum AutoValidateIfFocused {
  /// Don't auto validate while the field is in focus.
  ///
  /// The field is eligible for auto validation once the field
  /// is unfocused again.
  ignore,

  /// Validate after each value change when the field is in focus.
  checkAfterValueChanged,

  /// Set the field's validation state to neutral after each
  /// value change when the field is in focus.
  neutralAfterValueChanged,
}

/// Specifies events that must happen before a field is allowed to
/// auto validate.
enum AutoValidateWaitFor {
  /// Wait for the field to be unfocused for the first time.
  ///
  /// To be clear, the field _will_ be auto validated when its first
  /// unfocus occurs.
  firstUnfocus,

  /// Wait for the field to be force validated for the first time.
  firstForcedValidation,

  /// Wait for the field to either be unfocused for the first time or be
  /// force validated for the first time.
  ///
  /// To be clear, the field _will_ be auto validated when its first
  /// unfocus occurs.
  firstUnfocusOrForcedValidation,
}
