import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/config/constants.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_continue_button.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_file_upload_input.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_monthly_income_field.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_subtitle.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_title.dart';

class IncomePageDesktop extends StatelessWidget {
  const IncomePageDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: formWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32),
                IncomeTitle(),
                SizedBox(height: 8),
                IncomeSubtitle(),
                SizedBox(height: 24),
                IncomeMonthlyIncomeField(),
                SizedBox(height: 16),
                IncomeFileUploadInput(),
                SizedBox(height: 16),
                IncomeContinueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
