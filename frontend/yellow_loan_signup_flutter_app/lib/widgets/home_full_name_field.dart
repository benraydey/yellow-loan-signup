import 'package:flutter/material.dart';
import 'package:formy/formy.dart';
import 'package:yellow_loan_signup_flutter_app/config/app_form_field.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';

class HomeFullNameField extends StatelessWidget {
  const HomeFullNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return FormyTextField(
      name: AppFormField.fullName.name,
      label: AppLocalizations.of(context).homeFullNameLabel,
      validator: FormyStringValidator.name(),
    );
  }
}
