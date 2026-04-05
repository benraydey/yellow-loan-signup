import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/selected_phone_cubit/selected_phone_cubit.dart';
import 'package:yellow_loan_signup_flutter_app/pages/phone_details/widgets/phone_details_header.dart';
import 'package:yellow_loan_signup_flutter_app/pages/phone_details/widgets/phone_details_price_section.dart';
import 'package:yellow_loan_signup_flutter_app/pages/phone_details/widgets/phone_details_title_section.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/mobile_app_bar.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/phone_image_holder.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/submit_application_button.dart';

class PhoneDetailsPageMobile extends StatelessWidget {
  const PhoneDetailsPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedPhoneCubit, SelectedPhoneState>(
      builder: (context, state) {
        final phone = state.selectedPhone;

        if (phone == null) {
          return const Center(
            child: Text('No phone selected'),
          );
        }

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
                          const SizedBox(height: 32),
                          const PhoneDetailsHeader(),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 250,
                            child: Stack(
                              children: [
                                PhoneImageHolder(phone: phone),
                                // Back button in the top left corner
                                Positioned(
                                  top: 4,
                                  left: 4,
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: () => context.pop(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          PhoneDetailsTitleSection(phone: phone),
                          const SizedBox(height: 24),
                          PhoneDetailsPriceSection(phone: phone),
                          const SizedBox(height: 8),
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
              child: SubmitApplicationButton(),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
