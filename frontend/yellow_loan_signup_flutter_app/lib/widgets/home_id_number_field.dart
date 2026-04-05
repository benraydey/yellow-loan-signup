import 'package:flutter/material.dart';
import 'package:formy/formy.dart';
import 'package:yellow_loan_signup_flutter_app/config/app_form_field.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';
import 'package:yellow_loan_signup_flutter_app/util/home_continue.dart';

class HomeIdNumberField extends StatelessWidget {
  const HomeIdNumberField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormyTextField(
      name: AppFormField.idNumber.name,
      label: AppLocalizations.of(context).homeIdNumberLabel,
      validator: FormyStringValidator.idNumber(),
      onEditingComplete: () => homeContinue(context),
    );
  }
}
