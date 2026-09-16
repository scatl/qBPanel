import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 按可用宽度从左到右依次放下子项，放不下的整项隐藏（不换行、不均分、不裁切半个）。
class SequentialFitRow extends MultiChildRenderObjectWidget {
  const SequentialFitRow({
    super.key,
    required super.children,
    this.spacing = 16,
  });

  final double spacing;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSequentialFitRow(spacing: spacing);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderSequentialFitRow renderObject,
  ) {
    renderObject.spacing = spacing;
  }
}

class _SequentialFitParentData extends ContainerBoxParentData<RenderBox> {
  bool visible = true;
}

class RenderSequentialFitRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _SequentialFitParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _SequentialFitParentData> {
  RenderSequentialFitRow({required double spacing}) : _spacing = spacing;

  double _spacing;
  double get spacing => _spacing;
  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _SequentialFitParentData) {
      child.parentData = _SequentialFitParentData();
    }
  }

  @override
  void performLayout() {
    size = _layoutChildren(constraints, dry: false);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _layoutChildren(constraints, dry: true);
  }

  Size _layoutChildren(BoxConstraints constraints, {required bool dry}) {
    final maxWidth = constraints.maxWidth;
    final childConstraints = BoxConstraints(maxHeight: constraints.maxHeight);
    var used = 0.0;
    var height = 0.0;
    var fitting = true;
    var child = firstChild;
    while (child != null) {
      final parentData = child.parentData! as _SequentialFitParentData;
      final childSize = dry
          ? child.getDryLayout(childConstraints)
          : _layoutChild(child, childConstraints);
      final needed = used == 0
          ? childSize.width
          : used + spacing + childSize.width;
      if (fitting && needed <= maxWidth + 0.5) {
        if (!dry) {
          parentData.visible = true;
          parentData.offset = Offset(used == 0 ? 0 : used + spacing, 0);
        }
        used = needed;
        height = math.max(height, childSize.height);
      } else {
        fitting = false;
        if (!dry) {
          parentData.visible = false;
          parentData.offset = Offset.zero;
          child.layout(BoxConstraints.tight(Size.zero), parentUsesSize: true);
        }
      }
      child = childAfter(child);
    }
    return constraints.constrain(Size(used, height));
  }

  Size _layoutChild(RenderBox child, BoxConstraints constraints) {
    child.layout(constraints, parentUsesSize: true);
    return child.size;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    var child = lastChild;
    while (child != null) {
      final parentData = child.parentData! as _SequentialFitParentData;
      if (parentData.visible) {
        final current = child;
        final isHit = result.addWithPaintOffset(
          offset: parentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            return current.hitTest(result, position: transformed);
          },
        );
        if (isHit) return true;
      }
      child = parentData.previousSibling;
    }
    return false;
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    var child = firstChild;
    while (child != null) {
      final parentData = child.parentData! as _SequentialFitParentData;
      if (parentData.visible) visitor(child);
      child = childAfter(child);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var child = firstChild;
    while (child != null) {
      final parentData = child.parentData! as _SequentialFitParentData;
      if (parentData.visible) {
        context.paintChild(child, offset + parentData.offset);
      }
      child = childAfter(child);
    }
  }
}
