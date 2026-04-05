import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_space/grid_space.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/phone_list_bloc/phone_list_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/config/constants.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/card_grid.dart';
import 'package:yellow_loan_signup_flutter_app/pages/phone/phone_widgets.dart';

class PhonePageDesktop extends StatelessWidget {
  const PhonePageDesktop({super.key});

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

        return GridSpaceContainer(
          rules: const GridSpaceRules(
            itemWidth: 250,
            minItemsPerRow: 3,
            maxItemsPerRow: 5,
            itemHorizontalSpacing: gridItemSpacing,
            itemVerticalSpacing: gridItemSpacingLarge,
            itemAspectRatio: 158 / 200,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Center(
                child: PhoneListHeader(),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 64,
                ),
                child: CardGrid.desktop(
                  status: contentStatus,
                  loadedItemCount: state.phones.length,
                  loadedItemBuilder: (context, index) {
                    final phone = state.phones[index];
                    return PhoneCard(phone: phone);
                  },
                ),
              ),
              const SizedBox(height: 42),
            ],
          ),
        );
      },
    );
  }
}
