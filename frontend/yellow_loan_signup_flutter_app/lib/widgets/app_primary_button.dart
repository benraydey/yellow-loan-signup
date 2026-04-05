import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/default_loading_indicator.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.onPressed,
    super.key,
    this.title,
    this.isLoading = false,
    this.padding = EdgeInsets.zero,
    this.maxWidth = double.infinity,
    this.child,
    this.maxHeight,
    this.backgroundColor,
    this.useSecondaryColor,
    this.shimmerWhenEnabled = false,
    this.disabled = false,
    this.elevation = 2.0,
  }) : assert(
         backgroundColor == null || useSecondaryColor == null,
         'Cannot specify both backgroundColor and useSecondaryColor',
       );

  /// Title text to show.
  ///
  /// Ignored if [child] is not null.
  final String? title;

  final void Function()? onPressed;

  /// Padding around the button's child or title text
  final EdgeInsets padding;

  /// Whether to show a loading indicator instead of the child or title text
  final bool isLoading;

  /// Width to constrain the button to.
  ///
  /// Set to 0 to make the button as narrow as possible while still containing
  /// the child or title text.
  ///
  /// If null, button width will be [double.infinity]
  final double? maxWidth;

  /// Height to constrain the button to.
  ///
  /// If null, button height will be [defaultHeight]
  final double? maxHeight;

  /// Button color
  ///
  /// If left unspecified, button will be primary theme color.
  final Color? backgroundColor;

  /// Child widget to show instead of title text
  final Widget? child;

  /// Whether to use secondary theme color
  final bool? useSecondaryColor;

  /// Whether to show shimmer effect when button is enabled
  final bool shimmerWhenEnabled;

  /// Whether to show button is disabled
  final bool disabled;

  /// Elevation of the button
  final double elevation;

  double get defaultHeight => 70;

  double get height => maxHeight ?? defaultHeight;

  double get width => maxWidth ?? double.infinity;

  @override
  Widget build(BuildContext context) {
    var backgroundColorResolved = Color(0xFFDEDFE1);

    if (!disabled) {
      backgroundColorResolved =
          backgroundColor ??
          ((useSecondaryColor ?? false)
              ? Theme.of(context).buttonTheme.colorScheme!.secondary
              : Theme.of(context).buttonTheme.colorScheme!.primary);
    }

    return Skeleton.shade(
      child: shimmerWhenEnabled
          ? Stack(
              children: [
                if (onPressed != null)
                  Positioned.fill(
                    child: Shimmer.fromColors(
                      baseColor: backgroundColorResolved,
                      highlightColor: backgroundColorResolved.withOpacity(0.5),
                      enabled: shimmerWhenEnabled && onPressed != null,
                      child: ElevatedButton(
                        onPressed: disabled
                            ? null
                            : isLoading
                            ? () {}
                            : onPressed,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(width, height),
                          backgroundColor: backgroundColorResolved,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Container(), // Empty container
                      ),
                    ),
                  ),
                SizedBox(
                  height: maxHeight,
                  child: ElevatedButton(
                    onPressed: disabled
                        ? null
                        : isLoading
                        ? () {}
                        : onPressed,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width, height),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: padding,
                      child: isLoading
                          ? const DefaultLoadingIndicator()
                          : child ??
                                Text(
                                  title ?? '',
                                  style: Theme.of(context).textTheme.labelLarge!
                                      .copyWith(
                                        color: disabled
                                            ? Color(0xFF8f9394)
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                    ),
                  ),
                ),
              ],
            )
          : SizedBox(
              height: maxHeight,
              child: ElevatedButton(
                onPressed: disabled
                    ? null
                    : isLoading
                    ? () {}
                    : onPressed,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(width, height),
                  backgroundColor: backgroundColorResolved,
                  elevation: elevation,
                  foregroundColor: Theme.of(
                    context,
                  ).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: padding,
                  child: isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: DefaultLoadingIndicator(
                            strokeWidth: 3,
                          ),
                        )
                      : child ??
                            Text(
                              title ?? '',
                              style: Theme.of(context).textTheme.labelLarge!
                                  .copyWith(
                                    color: disabled
                                        ? Color(0xFF8f9394)
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                ),
              ),
            ),
    );
  }
}
