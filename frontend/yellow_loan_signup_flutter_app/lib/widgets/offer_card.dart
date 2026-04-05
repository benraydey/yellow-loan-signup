import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:yellow_loan_signup_flutter_app/config/constants.dart';

class BlankImage extends Image {
  BlankImage({
    super.key,
    super.width = double.infinity,
    super.height,
    super.fit = BoxFit.fill,
  }) : super.memory(
         const Base64Codec().decode(
           'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7',
         ),
       );
}

/// {@template offer_card}
/// Card displaying a promotion offer.
///
/// Exactly one of [headerHeight] or [bodyHeight] must not be null.
/// {@endtemplate}
class OfferCard extends StatelessWidget {
  /// {@macro offer_card}
  const OfferCard({
    super.key,
    this.onPressed,
    this.header,
    this.body,
    this.headerHeight,
    this.bodyHeight,
    this.bodyPaddingOn = true,
  }) : assert(
         (bodyHeight == null && headerHeight != null) ||
             (bodyHeight != null && headerHeight == null),
         'Exactly one of [headerHeight] or [bodyHeight] must not be null.',
       );

  /// Offer card to use inside a Skeletonizer
  factory OfferCard.skeleton() {
    return OfferCard(
      header: BlankImage(),
      body: const Text('Example offer promotion text.'),
      bodyHeight: 112,
    );
  }

  final void Function()? onPressed;
  final Widget? header;
  final Widget? body;
  final double? bodyHeight;
  final double? headerHeight;
  final bool bodyPaddingOn;

  @override
  Widget build(BuildContext context) {
    final bodyPadded = bodyPaddingOn
        ? Padding(
            padding: const EdgeInsets.all(contentMarginMedium),
            child: body,
          )
        : body;

    final bodyResolved = bodyHeight != null
        ? SizedBox(
            height: bodyHeight,
            child: bodyPadded,
          )
        : Expanded(child: bodyPadded ?? Container());

    final headerLeafed = Skeleton.replace(
      replacement: Skeleton.leaf(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(
              roundedContentRadius,
            ),
            topRight: Radius.circular(
              roundedContentRadius,
            ),
          ),
          child: BlankImage(),
        ),
      ),
      child: header ?? Container(),
    );

    final headerResolved = headerHeight != null
        ? SizedBox(
            height: headerHeight,
            child: headerLeafed,
          )
        : Expanded(child: headerLeafed);

    return PrimaryCard(
      onPressed: onPressed,
      elevation: offerCardElevation,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerResolved,
          bodyResolved,
        ],
      ),
    );
  }
}

class PrimaryCard extends StatelessWidget {
  const PrimaryCard({
    super.key,
    this.onPressed,
    this.child,
    this.clickEffectsOn,
    this.elevation = 10,
    this.margin,
    this.onHover,
  });

  final void Function()? onPressed;
  final Widget? child;

  final void Function(bool hovering)? onHover;

  /// Ignored if [onPressed] is null
  final bool? clickEffectsOn;
  final double elevation;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final clickEffectsOnResolved =
        (onPressed != null) && (clickEffectsOn ?? true);
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: onPressed,
          child: Card(
            margin: margin ?? EdgeInsets.zero,
            surfaceTintColor: Colors.white,
            color: Colors.white,
            elevation: elevation,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(roundedContentRadius),
              child: child,
            ),
          ),
        ),
        if (clickEffectsOnResolved)
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                onHover: onHover,
                borderRadius: roundedContentBorder,
              ),
            ),
          ),
      ],
    );
  }
}
