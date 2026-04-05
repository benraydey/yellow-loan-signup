import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/config/constants.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_continue_button.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_file_upload_input.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_monthly_income_field.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_subtitle.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_title.dart';

class IncomePageDesktop extends StatefulWidget {
  const IncomePageDesktop({super.key});

  @override
  State<IncomePageDesktop> createState() => _IncomePageDesktopState();
}

class _IncomePageDesktopState extends State<IncomePageDesktop> {
  final fileUploadKey = GlobalKey<State>();
  bool _showFileUploadError = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: formWidth,
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
            IncomeFileUploadInput(
              key: fileUploadKey,
              showError: _showFileUploadError,
            ),
            const SizedBox(height: 16),
            IncomeContinueButton(
              fileUploadKey: fileUploadKey,
              onFileUploadError: (show) =>
                  setState(() => _showFileUploadError = show),
            ),
          ],
        ),
      ),
    );
  }
}
