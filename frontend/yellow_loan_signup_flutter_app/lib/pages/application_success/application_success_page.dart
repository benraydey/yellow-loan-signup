import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/pages/application_success/application_success_page_desktop.dart';
import 'package:yellow_loan_signup_flutter_app/pages/application_success/application_success_page_mobile.dart';
import 'package:yellow_loan_signup_flutter_app/util/is_mobile.dart';

class ApplicationSuccessPage extends StatelessWidget {
  const ApplicationSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (isMobile(context)) {
      return const ApplicationSuccessPageMobile();
    } else {
      return const ApplicationSuccessPageDesktop();
    }
  }
}
