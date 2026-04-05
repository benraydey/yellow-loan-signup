import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formy/src/cubit/formy_cubit.dart';
import 'package:formy/src/models/auto_validate_rules.dart';
import 'package:formy/src/models/formy_field_state.dart';
import 'package:formy/src/models/types.dart';

abstract class FormyField<T> extends StatefulWidget {
  const FormyField({
    required this.name,
    required this.label,
    super.key,
    this.autoValidateRules,
    this.inheritAutoValidateRules = true,
    this.inheritNullValidator = true,
    this.validator,
    this.nullValidator,
    this.nullValues,
    this.unfocusOnTapOutside = true,
    this.autofocus = false,
    this.builder,
    this.inputDecorationEnabled = true,
    this.focusEnabled = true,
    this.initialValue,
  });

  /// Field name
  final String name;

  /// Field label shown to user
  final String label;

  /// Rules defining how this field is auto validated.
  ///
  /// If null, the field will not be auto validated.
  final AutoValidateRules? autoValidateRules;

  /// Validator function for this field.
  ///
  /// Validators return null if the field is valid otherwise a String of the
  /// error message.
  final ValidatorFunction<T>? validator;

  /// Null validator function for this field receives a nullable value.
  ///
  /// Validators return null if the field is valid otherwise a String of the
  /// error message.
  final NullValidatorFunction? nullValidator;

  /// Whether to inherit auto validate rules from the nearest ancestor formy
  /// widget if any.
  ///
  /// Ignored if [autoValidateRules] is not null.
  final bool inheritAutoValidateRules;

  /// Whether to inherit the null validator of the nearest ancestor formy
  /// widget if any.
  ///
  /// If [nullValidator] is not null, the inherited validator is ignored.
  ///
  /// If [nullValidator] is null and no inherited validator is found, a default
  /// error message is shown when the field is empty.
  final bool inheritNullValidator;

  /// Strings to be considered as null when passed to the null validator
  /// function
  final List<String>? nullValues;

  /// Whether to unfocus the field when tapped outside
  final bool unfocusOnTapOutside;

  /// Whether to request focus after being built
  final bool autofocus;

  /// Builds widget based on state
  final Widget Function(BuildContext context, FormyFieldState<T> fieldState)?
      builder;

  /// Whether input decoration is enabled
  final bool inputDecorationEnabled;

  /// Whether field is wrapped in a focus widget
  final bool focusEnabled;

  /// Initial value
  final T? initialValue;

  @override
  State<FormyField<T>> createState() =>
      FormyFieldWidgetState<T, FormyField<T>>();
}

class FormyFieldWidgetState<T, U extends FormyField<T>> extends State<U> {
  late String labelText;
  final focusNode = FocusNode();

  String? defaultNullValidator(T? value, String label) {
    if (value == null || widget.nullValues!.contains(value)) {
      return '$label is required';
    }
    return null;
  }

  @override
  @mustCallSuper
  void initState() {
    late FormyCubit formyCubit;
    try {
      formyCubit = context.read<FormyCubit>();
    } catch (e) {
      throw Exception(
        'FormyField must be a descendant of FormyCubit',
      );
    }
    late final AutoValidateRules? effectiveAutoValidateRules;
    if (widget.autoValidateRules != null) {
      effectiveAutoValidateRules = widget.autoValidateRules;
    } else if (widget.inheritAutoValidateRules) {
      effectiveAutoValidateRules = formyCubit.state.autoValidateRules;
    } else {
      effectiveAutoValidateRules = null;
    }

    final inheritedNullValidator =
        widget.inheritNullValidator ? formyCubit.state.nullValidator : null;

    late final ValidatorFunction<T?>? effectiveValidator;
    effectiveValidator = (value, label) {
      final effectiveValue =
          (widget.nullValues?.contains(value) ?? false) ? null : value;
      if (effectiveValue == null) {
        if (widget.nullValidator != null) {
          return widget.nullValidator!(effectiveValue, label);
        } else if (inheritedNullValidator != null) {
          return inheritedNullValidator(effectiveValue, label);
        }
        return defaultNullValidator(effectiveValue, label);
      } else {
        return widget.validator?.call(effectiveValue, label);
      }
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.addListener(_onFocusChanged);
    });

    formyCubit.registerField<T>(
      name: widget.name,
      label: widget.label,
      autoValidateRules: effectiveAutoValidateRules,
      validator: effectiveValidator,
      initialValue: widget.initialValue,
    );

    labelText = widget.label;
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (focusNode.hasFocus) {
      context.read<FormyCubit>().focus<T>(widget.name);
    } else {
      context.read<FormyCubit>().unfocus<T>(widget.name);
    }
  }

  T? get currentValue {
    return context.read<FormyCubit>().getValue<T>(widget.name);
  }

  void onChanged(T value) {
    context.read<FormyCubit>().updateValue<T>(
          widget.name,
          value,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FormyCubit, FormyState>(
      listenWhen: (previous, current) {
        final previousFieldState =
            previous.fields[widget.name]! as FormyFieldState<T>;
        final currentFieldState =
            current.fields[widget.name]! as FormyFieldState<T>;
        return previousFieldState != currentFieldState;
      },
      listener: (context, cubitState) {
        final fieldState =
            cubitState.fields[widget.name]! as FormyFieldState<T>;
        fieldListener(context, fieldState);
      },
      buildWhen: (previous, current) {
        final previousFieldState =
            previous.fields[widget.name]! as FormyFieldState<T>;
        final currentFieldState =
            current.fields[widget.name]! as FormyFieldState<T>;
        return previousFieldState != currentFieldState;
      },
      builder: (context, cubitState) {
        final fieldState =
            cubitState.fields[widget.name]! as FormyFieldState<T>;

        final focusChild = widget.inputDecorationEnabled
            ? InputDecorator(
                decoration: inputDecoration(
                  context,
                  fieldState,
                ),
                child: fieldBuilder(context, fieldState),
              )
            : fieldBuilder(context, fieldState);
        return widget.focusEnabled
            ? Focus(
                autofocus: widget.autofocus,
                focusNode: focusNode,
                child: focusChild,
              )
            : focusChild;
      },
    );
  }

  /// Basic input decorator for the field
  InputDecoration inputDecoration(
    BuildContext context,
    FormyFieldState<dynamic> fieldState,
  ) {
    return InputDecoration(
      labelText: labelText,
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

  Widget fieldBuilder(
    BuildContext context,
    FormyFieldState<T> fieldState,
  ) {
    return widget.builder?.call(context, fieldState) ?? Container();
  }

  void fieldListener(
    BuildContext context,
    FormyFieldState<T> fieldState,
  ) {}
}
