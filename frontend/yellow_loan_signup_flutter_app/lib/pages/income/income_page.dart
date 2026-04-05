import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/pages/income/income_page_desktop.dart';
import 'package:yellow_loan_signup_flutter_app/pages/income/income_page_mobile.dart';
import 'package:yellow_loan_signup_flutter_app/util/is_mobile.dart';

class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (isMobile(context)) {
      return const IncomePageMobile();
    } else {
      return const IncomePageDesktop();
    }
  }
}
