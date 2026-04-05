import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_continue_button.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_monthly_income_field.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_subtitle.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_title.dart';

class IncomePageMobile extends StatelessWidget {
  const IncomePageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const IncomeTitle(),
                const SizedBox(height: 8),
                const IncomeSubtitle(),
                const SizedBox(height: 24),
                const IncomeMonthlyIncomeField(),
                const SizedBox(height: 16),
                const IncomeContinueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
