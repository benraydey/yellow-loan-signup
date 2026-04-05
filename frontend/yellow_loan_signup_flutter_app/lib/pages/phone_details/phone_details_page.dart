import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/pages/phone_details/phone_details_page_desktop.dart';
import 'package:yellow_loan_signup_flutter_app/pages/phone_details/phone_details_page_mobile.dart';
import 'package:yellow_loan_signup_flutter_app/util/is_mobile.dart';

class PhoneDetailsPage extends StatelessWidget {
  const PhoneDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (isMobile(context)) {
      return const PhoneDetailsPageMobile();
    } else {
      return const PhoneDetailsPageDesktop();
    }
  }
}
