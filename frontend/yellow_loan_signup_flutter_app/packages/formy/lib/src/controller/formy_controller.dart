import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formy/src/cubit/formy_cubit.dart';

class FormyController {
  const FormyController._(
    FormyCubit cubit,
    BuildContext context,
  )   : _cubit = cubit,
        _context = context;

  final FormyCubit _cubit;
  final BuildContext _context;

  static FormyController of(BuildContext context) {
    final cubit = FormyCubit.of(context);
    return FormyController._(cubit, context);
  }

  static FormyController? maybeOf(BuildContext context) {
    final cubit = FormyCubit.maybeOf(context);
    return cubit != null ? FormyController._(cubit, context) : null;
  }

  /// Validates the fields in scope, returning true if the fields are valid,
  /// false otherwise.
  ///
  /// [include] can be used to specify the fields to validate. If not provided,
  /// all fields in scope minus those specified in [exclude] will be validated.
  bool validate({List<String>? include, List<String>? exclude}) {
    assert(
      include == null || exclude == null,
      'Cannot provide both include and exclude',
    );
    _cubit.validate(include: include, exclude: exclude);
    return _cubit.state.isValid;
  }

  /// Returns all fields as key-value pairs
  ///
  /// [include] can be used to specify the fields to collect. If not provided,
  /// all fields in scope minus those specified in [exclude] will be collected.

  Map<String, dynamic> collect({List<String>? include, List<String>? exclude}) {
    assert(
      include == null || exclude == null,
      'Cannot provide both include and exclude',
    );

    final fields = _cubit.state.fields;
    final collected = <String, dynamic>{};
    fields.forEach((key, value) {
      if (include != null && !include.contains(key)) {
        return;
      }
      if (exclude != null && exclude.contains(key)) {
        return;
      }
      collected[key] = value.value;
    });
    return collected;
  }

  /// Returns the value of the field with the given [name], and marks
  /// this widget for rebuild whenever the field changes.
  ///
  /// If the field is not found, null is returned
  T? watchValue<T>(String name) {
    return _context.select((FormyCubit cubit) {
      return cubit.state.fields[name]?.value as T?;
    });
  }

  /// Returns the value of the field with the given [name]
  ///
  /// If the field is not found, null is returned
  T? getValue<T>(String name) {
    return _cubit.getValue<T>(name);
  }

  /// Resets the value of the field with the given [name] to its initial state
  void resetValue(String name) {
    if (hasField(name)) {
      _cubit.resetValue(name);
    }
  }

  /// Reset the value of the field with the given [name] to its initial state
  /// if the field exists
  void maybeResetValue(String name) {
    if (_cubit.state.fields.containsKey(name)) {
      _cubit.resetValue(name);
    }
  }

  /// Resets all fields to their initial state
  void reset() {
    _cubit.reset();
  }

  /// Updates the value of the field with the given [name] to the specified value
  void updateValue<T>(String name, T? value, {bool? isFocused}) {
    _cubit.updateValue(name, value, isFocused: isFocused);
  }

  /// Whether formy has been edited
  bool get hasEditingStarted => _cubit.state.hasEditingStarted;

  /// Checks if a field with the given [name] is registered
  bool hasField(String name) {
    return _cubit.hasField(name);
  }

  /// Checks if the field with the given [fieldName] is valid
  bool isFieldValid(String fieldName) {
    final field = _cubit.state.fields[fieldName];
    return field?.isValidInstant ?? false;
  }
}
