import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grid_space/grid_space.dart';

/// A flutter widget that creates a grid whose width and item count per row
/// is determined by an ancestor [GridSpaceContainer] widget.
class GridSpaceBuilder extends StatelessWidget {
  /// Creates a grid with width and item count per row determined by an
  /// ancestor [GridSpaceContainer] widget.
  const GridSpaceBuilder({
    required this.itemBuilder,
    required this.itemCount,
    super.key,
    this.itemAspectRatio,
    this.itemVerticalSpacing,
    this.center = false,
    this.maxHeight,
    this.fixedHeight,
  });

  /// Function returning a widget for each grid index.
  final Widget? Function(BuildContext context, int index) itemBuilder;

  /// Whether to center items when there are less items than numItemsPerRow
  final bool center;

  /// Maximum height of items
  final double? maxHeight;

  final double? fixedHeight;

  /// Number of items in grid.
  final int itemCount;

  /// Width / height of each item.
  ///
  /// Takes precedence over inherited [itemAspectRatio].
  /// If null and no inherited [itemAspectRatio] is set, a ratio of 1 will be
  /// used.
  final double? itemAspectRatio;

  /// Height of gap between rows of items.
  ///
  /// Takes precedence over inherited [itemVerticalSpacing].
  /// If null and no inherited [itemVerticalSpacing] is set, horizontalSpacing
  /// will be used.
  final double? itemVerticalSpacing;

  @override
  Widget build(BuildContext context) {
    assert(
      GridSpace.maybeOf(context) != null,
      "Couldn't find a $GridSpace in the given context. "
      '$GridSpaceBuilder must have a $GridSpaceContainer as an ancestor.',
    );
    final gridSpaceProvider = GridSpace.of(context);

    final itemCountPerRow = gridSpaceProvider.itemCountPerRow;
    final itemHorizontalSpacing = gridSpaceProvider.itemHorizontalSpacing;

    final itemAspectRatioResolved =
        gridSpaceProvider.itemAspectRatio ?? itemAspectRatio ?? 1;
    final verticalSpacingResolved = gridSpaceProvider.itemVerticalSpacing ??
        itemVerticalSpacing ??
        itemHorizontalSpacing;

    if (center) {
      return LayoutBuilder(
        builder: (context, constraints) {
          late final double itemWidth;
          if (itemCountPerRow == 1) {
            itemWidth = constraints.maxWidth;
          } else {
            itemWidth = (constraints.maxWidth / itemCountPerRow) -
                ((itemCountPerRow - 1) * itemHorizontalSpacing);
          }
          final itemHeight = itemWidth / itemAspectRatioResolved;
          final heightResolved = fixedHeight ??
              (maxHeight != null ? min(maxHeight!, itemHeight) : itemHeight);

          final numRows = (itemCount / itemCountPerRow).ceil();
          final columnChildren = <Widget>[];
          var index = 0;
          for (var row = 0; row < numRows; row++) {
            if (index == itemCount) {
              break;
            }
            final rowChildren = <Widget>[];
            for (var col = 0; col < itemCountPerRow; col++) {
              if (index == itemCount) {
                break;
              }
              final item = itemBuilder(context, index);
              rowChildren.add(
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        height: heightResolved,
                        child: item,
                      );
                    },
                  ),
                ),
              );
              index++;
            }
            columnChildren.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: rowChildren.intersperse(
                  SizedBox(
                    width: itemHorizontalSpacing,
                  ),
                ),
              ),
            );
          }
          return Column(
            children: columnChildren.intersperse(
              SizedBox(
                height: verticalSpacingResolved,
              ),
            ),
          );
        },
      );
    }

    // if (itemCount < itemCountPerRow) {
    //   return Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       for (var index = 0; index < itemCount; index++)
    //         Expanded(
    //           child: LayoutBuilder(
    //             builder: (context, constraints) {
    //               return SizedBox(
    //                 height: constraints.maxWidth / itemAspectRatioResolved,
    //                 child: itemBuilder(context, index),
    //               );
    //             },
    //           ),
    //         ),
    //     ].intersperse(
    //       SizedBox(width: itemHorizontalSpacing),
    //     ),
    //   );
    // }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemCountPerRow,
        childAspectRatio: itemAspectRatioResolved,
        crossAxisSpacing: itemHorizontalSpacing,
        mainAxisSpacing: verticalSpacingResolved,
      ),
      clipBehavior: Clip.none,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      padding: EdgeInsets.zero,
    );
  }
}

extension ListExtension<T> on List<T> {
  /// Adds [element] between each item of this list.
  ///
  /// If [surround] is true, [element] will also be added to the start and end
  /// of the list.
  List<T> intersperse(
    T element, {
    bool surround = false,
  }) {
    var i = 0;
    while (i < length - 1) {
      insert(i + 1, element);
      i = i + 2;
    }
    if (surround) {
      return [element, ...this, element];
    } else {
      return this;
    }
  }
}
