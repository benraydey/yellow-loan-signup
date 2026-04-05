// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formy/src/controller/formy_controller.dart';
import 'package:formy/src/cubit/formy_cubit.dart';
import 'package:formy/src/models/auto_validate_rules.dart';
import 'package:formy/src/models/types.dart';

// /// Options for how the validator of the nearest ancestor formy widget should be
// /// used if one is found.
// enum InheritedValidatorOptions {
//   /// Call the inherited validator before this widget's validator
//   addBefore,
//
//   /// Call the inherited validator after this widget's validator
//   addAfter,
//
//   /// Replace this widget's validator with the inherited validator
//   replace,
//
//   /// Ignore the inherited validator
//   ignore,
// }

class Formy extends StatelessWidget {
  const Formy({
    required this.child,
    this.autoValidateRules,
    this.nullValidator,
    this.inheritAutoValidateRules = true,
    this.inheritNullValidator = true,
    super.key,
  });

  final Widget child;

  /// Whether to inherit auto validate rules from the nearest ancestor formy
  /// widget if any.
  ///
  /// Ignored if [autoValidateRules] is not null.
  final bool inheritAutoValidateRules;

  /// Whether to inherit the null validator of the nearest ancestor formy widget
  /// if any.
  ///
  /// If [nullValidator] is not null, the inherited validator if found will be
  /// called before this field's validator.
  final bool inheritNullValidator;

  /// Auto validate rules to be inherited by all formy fields lower in the
  /// widget tree.
  ///
  /// Formy fields can override these rules by setting their own auto validate
  final AutoValidateRules? autoValidateRules;

  /// Validator to be inherited by all formy fields lower in the widget tree
  ///
  /// Useful for setting a global null validator like '<field label> is
  /// required'.
  ///
  /// Formy fields can choose to ignore this validator
  final NullValidatorFunction? nullValidator;

  @override
  Widget build(BuildContext context) {
    late final NullValidatorFunction? effectiveValidator;
    late final AutoValidateRules? effectiveAutoValidateRules;

    final formyCubit = FormyCubit.maybeOf(context);

    if (autoValidateRules != null) {
      effectiveAutoValidateRules = autoValidateRules;
    } else if (inheritAutoValidateRules) {
      final maybeCubit = FormyCubit.maybeOf(context);
      effectiveAutoValidateRules = maybeCubit?.state.autoValidateRules;
    } else {
      effectiveAutoValidateRules = null;
    }

    if (nullValidator != null) {
      effectiveValidator = nullValidator;
    } else if (inheritNullValidator) {
      final maybeCubit = FormyCubit.maybeOf(context);
      effectiveValidator = maybeCubit?.state.nullValidator;
    } else {
      effectiveValidator = null;
    }

    return BlocProvider(
      create: (context) => FormyCubit(
        autoValidateRules: effectiveAutoValidateRules,
        nullValidator: effectiveValidator,
      ),
      child: child,
    );
  }

  static FormyController of(BuildContext context) {
    return FormyController.of(context);
  }

  static FormyController? maybeOf(BuildContext context) {
    return FormyController.maybeOf(context);
  }
}
