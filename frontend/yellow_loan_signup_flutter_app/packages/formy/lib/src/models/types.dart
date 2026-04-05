/// Callback for validation
typedef ValidatorFunction<T> = String? Function(
  T value,
  String label,
);

typedef NullValidatorFunction = String? Function(
  dynamic value,
  String label,
);

// /// Widget builder
// typedef FieldBuilder<T> = Widget Function(
//   BuildContext context,
//   FormyFieldState<T> state,
// );
