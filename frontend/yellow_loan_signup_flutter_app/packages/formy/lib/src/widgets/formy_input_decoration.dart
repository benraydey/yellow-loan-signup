import 'package:flutter/material.dart';
import 'package:formy/src/models/formy_field_state.dart';

/// Basic input decorator for the field
InputDecoration formyInputDecoration(
  BuildContext context,
  FormyFieldState<dynamic> fieldState,
) {
  return InputDecoration(
    labelText: fieldState.label,
    errorText: fieldState.error,
    errorMaxLines: 5,
    border: const OutlineInputBorder(),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
      ),
    ),
  );
}
