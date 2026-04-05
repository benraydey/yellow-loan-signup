import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/util/age_calculator.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/home_age_text.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/home_continue_button.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/home_full_name_field.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/home_id_number_field.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/home_subtitle.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/home_title.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/mobile_app_bar.dart';

class HomePageMobile extends StatelessWidget {
  const HomePageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final age = calculateAgeFromIdNumber(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              const MobileAppBarSliver(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const HomeTitle(),
                      const SizedBox(height: 8),
                      const HomeSubtitle(),
                      const SizedBox(height: 24),
                      const HomeFullNameField(),
                      const SizedBox(height: 8),
                      const HomeIdNumberField(),
                      if (age != null) HomeAgeText(age: age),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: HomeContinueButton(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
