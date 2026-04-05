import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formy/src/models/auto_validate_rules.dart';
import 'package:formy/src/models/formy_field_state.dart';
import 'package:formy/src/models/types.dart';

part 'formy_state.dart';

class FormyCubit extends Cubit<FormyState> {
  FormyCubit({
    AutoValidateRules? autoValidateRules,
    NullValidatorFunction? nullValidator,
  }) : super(
          FormyState(
            autoValidateRules: autoValidateRules,
            nullValidator: nullValidator,
          ),
        );

  void registerField<T>({
    required String name,
    required String label,
    AutoValidateRules? autoValidateRules,
    ValidatorFunction<T?>? validator,
    T? initialValue,
  }) {
    late final FormyFieldState<T> newOrUpdatedField;
    if (state.fields.containsKey(name)) {
      newOrUpdatedField = (state.fields[name]! as FormyFieldState<T>)
          .copyWith(
            label: label,
            autoValidateRules: autoValidateRules,
            validator: validator,
            updateValidator: true,
            value: initialValue,
            updateValue: initialValue != null,
          )
          .maybeAutoValidated(otherFieldChanged: false);
    } else {
      newOrUpdatedField = FormyFieldState<T>(
        name: name,
        label: label,
        autoValidateRules: autoValidateRules,
        validator: validator,
        value: initialValue,
      );
    }

    final updatedFields = <String, FormyFieldState<dynamic>>{}
      ..addAll(state.fields);
    updatedFields[name] = newOrUpdatedField;

    emit(state.copyWith(fields: updatedFields));
  }

  /// Called when field loses focus
  void unfocus<T>(String name) {
    final newField = (state.fields[name]! as FormyFieldState<T?>)
        .copyWith(
          hasBeenUnfocused: true,
          isFocused: false,
        )
        .maybeAutoValidated(otherFieldChanged: false);
    final updatedFields = <String, FormyFieldState<dynamic>>{}
      ..addAll(state.fields);
    updatedFields[name] = newField;
    emit(state.copyWith(fields: updatedFields));
  }

  /// Called when field gains focus
  void focus<T>(String name) {
    final newField = (state.fields[name]! as FormyFieldState<T?>).copyWith(
      isFocused: true,
    );
    final updatedFields = <String, FormyFieldState<dynamic>>{}
      ..addAll(state.fields);
    updatedFields[name] = newField;
    emit(state.copyWith(fields: updatedFields));
  }

  /// Called when field's value changes
  void updateValue<T>(String name, T? value, {bool? isFocused}) {
    assert(
      state.fields.containsKey(name),
      "Field with name '$name' not registered.",
    );
    final newField = (state.fields[name]! as FormyFieldState<T?>)
        .copyWith(
          value: value,
          updateValue: true,
          isFocused: isFocused,
          hasBeenUnfocused:
              !(isFocused ?? true) || state.fields[name]!.hasBeenUnfocused,
        )
        .maybeAutoValidated(otherFieldChanged: false);
    final updatedFields = <String, FormyFieldState<dynamic>>{};
    updatedFields[name] = newField;

    state.fields.forEach(
      (key, field) {
        if (key != name) {
          updatedFields[key] =
              field.maybeAutoValidated(otherFieldChanged: true);
        }
      },
    );
    emit(state.copyWith(fields: updatedFields, hasEditingStarted: true));
  }

  T? getValue<T>(String name) {
    return state.fields[name]?.value as T?;
  }

  /// resets the form value to its initial state
  void resetValue(String name) {
    assert(
      state.fields.containsKey(name),
      "Field with name '$name' not registered.",
    );
    final updatedFields = <String, FormyFieldState<dynamic>>{}
      ..addAll(state.fields);
    final newField = state.fields[name]!.reset;
    updatedFields[name] = newField;

    state.fields.forEach(
      (key, field) {
        if (key != name) {
          updatedFields[key] =
              field.maybeAutoValidated(otherFieldChanged: true);
        }
      },
    );
    emit(state.copyWith(fields: updatedFields, hasEditingStarted: true));
  }

  /// Resets all fields to their initial state
  void reset() {
    final updatedFields = <String, FormyFieldState<dynamic>>{};
    state.fields.forEach((key, field) {
      updatedFields[key] = field.reset;
    });
    emit(state.copyWith(fields: updatedFields, hasEditingStarted: true));
  }

  static FormyCubit of(BuildContext context) {
    return context.read<FormyCubit>();
  }

  static FormyCubit? maybeOf(BuildContext context) {
    try {
      return context.read<FormyCubit>();
    } catch (_) {
      return null;
    }
  }

  void validate({List<String>? include, List<String>? exclude}) {
    final updatedFields = <String, FormyFieldState<dynamic>>{};
    var isValid = true;
    state.fields.forEach((key, field) {
      if (include != null && !include.contains(key)) {
        updatedFields[key] = field;
        return;
      }
      if (exclude != null && exclude.contains(key)) {
        updatedFields[key] = field;
        return;
      }
      updatedFields[key] = field.validated;
      isValid = isValid && field.isValidInstant;
    });
    emit(
      state.copyWith(
        fields: updatedFields,
        isValid: isValid,
      ),
    );
  }

  bool hasField(String name) {
    return state.fields.containsKey(name);
  }
}
