import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/pages/home/home_page_desktop.dart';
import 'package:yellow_loan_signup_flutter_app/pages/home/home_page_mobile.dart';
import 'package:yellow_loan_signup_flutter_app/util/is_mobile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (isMobile(context)) {
      return const HomePageMobile();
    } else {
      return const HomePageDesktop();
    }
  }
}
