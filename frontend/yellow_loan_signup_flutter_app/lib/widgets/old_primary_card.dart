import 'package:flutter/material.dart';

class OldPrimaryCard extends StatelessWidget {
  const OldPrimaryCard({
    super.key,
    this.onPressed,
    this.child,
    this.clickEffectsOn,
    this.elevation = 10,
    this.margin,
  });

  final void Function()? onPressed;
  final Widget? child;

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
            margin: margin,
            surfaceTintColor: Colors.white,
            color: Colors.white,
            elevation: elevation,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
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
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
