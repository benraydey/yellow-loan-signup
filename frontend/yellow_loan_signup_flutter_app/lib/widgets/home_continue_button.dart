import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';
import 'package:yellow_loan_signup_flutter_app/util/home_continue.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/app_primary_button.dart';

class HomeContinueButton extends StatelessWidget {
  const HomeContinueButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      title: AppLocalizations.of(context).buttonContinue,
      onPressed: () async {
        await homeContinue(context);
      },
    );
  }
}
