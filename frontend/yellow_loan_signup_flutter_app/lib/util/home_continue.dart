import 'package:flutter/material.dart';
import 'package:formy/formy.dart';
import 'package:go_router/go_router.dart';
import 'package:yellow_loan_signup_flutter_app/config/app_form_field.dart';
import 'package:yellow_loan_signup_flutter_app/config/constants.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';
import 'package:yellow_loan_signup_flutter_app/util/age_calculator.dart';

Future<void> homeContinue(BuildContext context) async {
  final age = calculateAgeFromIdNumber(context);
  if (Formy.of(context).validate(
    include: [
      AppFormField.fullName.name,
      AppFormField.idNumber.name,
    ],
  )) {
    if (age != null && age >= loanMinAge && age <= loanMaxAge) {
      await context.push('/income');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(
              context,
            ).homeInvalidAge(loanMinAge, loanMaxAge),
          ),
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }
}
