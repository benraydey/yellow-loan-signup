import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formy/formy.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/index.dart';
import 'package:yellow_loan_signup_flutter_app/config/app_form_field.dart';
import 'package:yellow_loan_signup_flutter_app/config/constants.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';
import 'package:yellow_loan_signup_flutter_app/util/age_calculator.dart';
import 'package:yellow_loan_signup_flutter_app/util/is_mobile.dart';

Future<void> homeContinue(BuildContext context) async {
  final age = calculateAgeFromIdNumber(context);
  if (Formy.of(context).validate(
    include: [
      AppFormField.fullName.name,
      AppFormField.idNumber.name,
    ],
  )) {
    if (age != null && age >= loanMinAge && age <= loanMaxAge) {
      final idNumber = Formy.of(
        context,
      ).getValue<String>(AppFormField.idNumber.name);
      if (idNumber != null) {
        context.read<ApplicationStartBloc>().add(
          StartApplication(idNumber: idNumber),
        );
      }
    } else {
      if (!isMobile(context)) {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Invalid Age'),
            content: Text(
              AppLocalizations.of(
                context,
              ).homeInvalidAge(loanMinAge, loanMaxAge),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }
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
