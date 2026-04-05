import 'package:flutter/material.dart';
import 'package:formy/formy.dart';
import 'package:yellow_loan_signup_flutter_app/config/app_form_field.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';

class IncomeMonthlyIncomeField extends StatelessWidget {
  const IncomeMonthlyIncomeField({super.key});

  @override
  Widget build(BuildContext context) {
    return FormyTextField(
      name: AppFormField.monthlyIncome.name,
      label: AppLocalizations.of(context).incomeMonthlyIncomeLabel,
      keyboardType: TextInputType.number,
      validator: FormyStringValidator.paymentAmount(min: 0, max: 1000000000),
      addCurrencyPrefix: true,
    );
  }
}
