import 'package:flutter/material.dart';
import 'package:formy/formy.dart';
import 'package:go_router/go_router.dart';
import 'package:yellow_loan_signup_flutter_app/config/app_form_field.dart';
import 'package:yellow_loan_signup_flutter_app/pages/income/income_page_desktop.dart';
import 'package:yellow_loan_signup_flutter_app/pages/income/income_page_mobile.dart';
import 'package:yellow_loan_signup_flutter_app/util/is_mobile.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Check if the form is valid
      final isFormValid = Formy.of(context).validate(
        include: [
          AppFormField.fullName.name,
          AppFormField.idNumber.name,
        ],
      );

      // If the form is not valid, redirect to home page
      if (!isFormValid) {
        await context.push('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isMobile(context)) {
      return const IncomePageMobile();
    } else {
      return const IncomePageDesktop();
    }
  }
}
