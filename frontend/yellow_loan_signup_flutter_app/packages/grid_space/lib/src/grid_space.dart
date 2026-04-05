import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:grid_space/grid_space.dart';

/// Object that holds the data for a [GridSpace] so a
/// [GridSpaceBuilder] further down in the widget tree knows how many items
/// per row are allowed.
class GridSpaceData extends Equatable {
  /// Creates a [GridSpaceData] object.
  const GridSpaceData({
    required this.itemCountPerRow,
    required this.itemHorizontalSpacing,
    required this.contentWidth,
    this.itemAspectRatio,
    this.itemVerticalSpacing,
  });

  /// Number of items per row (i.e. the number of columns).
  final int itemCountPerRow;

  /// Space between each item
  final double itemHorizontalSpacing;

  /// Width / height of each item.
  final double? itemAspectRatio;

  /// Height of gap between rows of items.
  final double? itemVerticalSpacing;

  final double contentWidth;

  @override
  List<Object?> get props => throw UnimplementedError();
}

/// Inherited widget which maintains the state of a page with grid content.
class GridSpace extends InheritedWidget implements Equatable {
  /// Creates a [GridSpace] widget.
  const GridSpace({
    required this.data,
    required super.child,
    super.key,
  });

  /// State data
  final GridSpaceData data;

  /// Returns the [data] of the nearest [GridSpace] in the hierarchy if any.
  static GridSpaceData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GridSpace>()?.data;
  }

  /// Returns the [data] of the nearest [GridSpace] in the hierarchy if there
  /// is one, otherwise throws an exception.
  static GridSpaceData of(BuildContext context) {
    final result = maybeOf(context);
    assert(
      result != null,
      '$GridSpaceData requested within a context that does not include a '
      '$GridSpace. This call should only be used in a context that has '
      'a $GridSpaceContainer as an ancestor.',
    );
    return result!;
  }

  @override
  bool updateShouldNotify(GridSpace oldWidget) {
    return oldWidget != this;
  }

  @override
  List<Object?> get props => [data];

  @override
  bool? get stringify => true;
}
