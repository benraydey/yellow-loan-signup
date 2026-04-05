import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_space/grid_space.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/phone_list_bloc/phone_list_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/config/constants.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/card_grid.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/mobile_app_bar.dart';
import 'package:yellow_loan_signup_flutter_app/pages/phone/phone_widgets.dart';

class PhonePageMobile extends StatelessWidget {
  const PhonePageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneListBloc, PhoneListState>(
      builder: (context, state) {
        final ContentStatus contentStatus;
        if (state.isLoading) {
          contentStatus = ContentStatus.loading;
        } else if (state.status == PhoneListStatus.error) {
          contentStatus = ContentStatus.error;
        } else if (state.phones.isEmpty) {
          contentStatus = ContentStatus.loaded;
        } else {
          contentStatus = ContentStatus.loaded;
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
                      child: GridSpaceContainer(
                        rules: const GridSpaceRules(
                          itemWidth: 180,
                          itemMinWidth: 180,
                          minItemsPerRow: 2,
                          maxItemsPerRow: 5,
                          itemHorizontalSpacing: gridItemSpacing,
                          itemVerticalSpacing: gridItemSpacingLarge,
                          itemAspectRatio: 158 / 200,
                        ),
                        allowMargin: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            const PhoneListHeader(),
                            const SizedBox(height: 24),
                            CardGrid.mobile(
                              status: contentStatus,
                              loadedItemCount: state.phones.length,
                              loadedItemBuilder: (context, index) {
                                final phone = state.phones[index];
                                return PhoneCard(phone: phone);
                              },
                            ),
                            const SizedBox(height: 42),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
