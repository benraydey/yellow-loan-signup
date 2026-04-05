import 'package:flutter/material.dart';

enum ColorSelection { primary, onPrimary }

class DefaultLoadingIndicator extends StatelessWidget {
  const DefaultLoadingIndicator({
    this.color = ColorSelection.onPrimary,
    this.customColor,
    this.strokeWidth = 4,
    super.key,
  });

  factory DefaultLoadingIndicator.inverse() => const DefaultLoadingIndicator(
        color: ColorSelection.primary,
      );

  /// Color to use instead of default color.
  ///
  /// If not null, [color] will be ignored.
  final Color? customColor;

  /// Specifies theme color to use
  final ColorSelection? color;

  /// The width of the line used to draw the circle.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final colorResolved = customColor ??
        (color == ColorSelection.primary
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onPrimary);
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        color: colorResolved,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
