import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_continue_button.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_file_upload_input.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_monthly_income_field.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_subtitle.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_title.dart';

class IncomePageMobile extends StatefulWidget {
  const IncomePageMobile({super.key});

  @override
  State<IncomePageMobile> createState() => _IncomePageMobileState();
}

class _IncomePageMobileState extends State<IncomePageMobile> {
  final fileUploadKey = GlobalKey<State>();
  bool _showFileUploadError = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
    );
  }
}
