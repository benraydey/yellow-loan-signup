import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yellow_loan_signup_flutter_app/app/router/app_router.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/selected_phone_cubit/selected_phone_cubit.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';
import 'package:yellow_loan_signup_flutter_app/model/phone.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/offer_card.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/phone_image_holder.dart';

/// Header widget for the phone list page with title and subtitle
class PhoneListHeader extends StatelessWidget {
  const PhoneListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).phonesTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context).phonesSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

/// Card widget for displaying a single phone offer
class PhoneCard extends StatelessWidget {
  const PhoneCard({
    required this.phone,
    super.key,
  });

  final Phone phone;

  @override
  Widget build(BuildContext context) {
    return OfferCard(
      onPressed: () async {
        context.read<SelectedPhoneCubit>().selectPhone(phone);
        await context.push(AppRoute.phoneDetails.path);
      },
      header: PhoneImageHolder(phone: phone),
      bodyHeight: 90,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AutoSizeText(
              phone.title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          AutoSizeText(
            '${phone.dailyPaymentInRands} per day',
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
