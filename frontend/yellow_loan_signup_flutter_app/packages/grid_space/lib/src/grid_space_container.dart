import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:grid_space/grid_space.dart';
import 'package:grid_space/src/utils.dart';

/// Object that holds the rules a [GridSpaceContainer] should use to determine
/// grid width and number of items per row.
///
/// [GridSpaceBuilder] widgets further down the widget tree will use the values
/// in this [GridSpaceRules] unless the [GridSpaceBuilder]'s properties
/// override them.
class GridSpaceRules extends Equatable {
  /// Creates a [GridSpaceRules] object.
  ///
  /// If [itemMinWidth] is not specified, [itemWidth] is used.
  const GridSpaceRules({
    required this.itemWidth,
    required this.itemHorizontalSpacing,
    required this.minItemsPerRow,
    this.contentMinWidth = 0,
    double? itemMinWidth,
    this.itemVerticalSpacing,
    this.itemAspectRatio,
    this.maxItemsPerRow,
  }) : itemMinWidth = itemMinWidth ?? itemWidth;

  /// The width of each item when there is sufficient horizontal space.
  final double itemWidth;

  /// The minimum width of each item.
  final double itemMinWidth;

  /// Space between columns of items
  final double itemHorizontalSpacing;

  /// The minimum number of items allowed per row
  final int minItemsPerRow;

  /// If a margin would cause the content width to be less than
  /// [contentMinWidth], the margin will be zero.
  final double contentMinWidth;

  /// Space between rows of items.
  ///
  /// Can be overridden by a property of a [GridSpaceBuilder].
  final double? itemVerticalSpacing;

  /// Width divided by height of each item.
  ///
  /// Can be overridden by a property of a [GridSpaceBuilder].
  final double? itemAspectRatio;

  /// The maximum number of items per row
  final int? maxItemsPerRow;

  @override
  List<Object?> get props => [
        itemWidth,
        itemMinWidth,
        itemHorizontalSpacing,
        minItemsPerRow,
        contentMinWidth,
        itemVerticalSpacing,
        itemAspectRatio,
        maxItemsPerRow,
      ];
}

/// Flutter widget that handles the state of a page containing grid content
/// and constrains a child widget such that it's width matches the grid width.
class GridSpaceContainer extends StatelessWidget {
  /// Creates a [GridSpaceContainer] widget.
  const GridSpaceContainer({
    required this.rules,
    required this.child,
    super.key,
    this.allowMargin = true,
  });

  /// Rules to determine width and item count per row.
  final GridSpaceRules rules;

  /// Whether this widget can place a margin on either side of the [child]
  /// widget to constrain it to the calculated grid width.
  final bool allowMargin;

  /// Child widget
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final numItemsPerRow = calcNumItemsPerRow(
          contentMaxWidth: constraints.maxWidth,
          itemWidth: rules.itemWidth,
          itemSpacing: rules.itemHorizontalSpacing,
          minItemsPerRow: rules.minItemsPerRow,
          maxItemsPerRow: rules.maxItemsPerRow,
          itemMinWidth: rules.itemMinWidth,
          contentMinWidth: rules.contentMinWidth,
        );

        final totalWidthOfGrid = contentWidth(
          numItemsPerRow,
          rules.itemWidth,
          rules.itemHorizontalSpacing,
        );

        final allowMarginResolved = numItemsPerRow != rules.minItemsPerRow &&
            allowMargin &&
            totalWidthOfGrid >= rules.contentMinWidth;

        return Center(
          child: SizedBox(
            width: allowMarginResolved ? totalWidthOfGrid : double.infinity,
            child: GridSpace(
              data: GridSpaceData(
                itemCountPerRow: numItemsPerRow,
                itemHorizontalSpacing: rules.itemHorizontalSpacing,
                itemAspectRatio: rules.itemAspectRatio,
                itemVerticalSpacing: rules.itemVerticalSpacing,
                contentWidth:
                    allowMarginResolved ? totalWidthOfGrid : double.infinity,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
