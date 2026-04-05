import 'package:flutter/material.dart';
import 'package:formy/formy.dart';
import 'package:go_router/go_router.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/app_primary_button.dart';

class IncomeContinueButton extends StatelessWidget {
  const IncomeContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      title: AppLocalizations.of(context).buttonContinue,
      onPressed: () {
        if (Formy.of(context).validate()) {
          // Navigate to next page
          // context.push('/next-page');
        }
      },
    );
  }
}
