import 'dart:math';

import 'package:flutter/material.dart';
class OuterList extends NotificationListener<ScrollNotification> {
  OuterList({child, onNotification})
      : super(
          child: child,
          onNotification: onNotification,
        );

  factory OuterList.builder({
    Key key,
    @required
        double Function(ScrollMetrics position, double innerVelocity)
            velocityFunc,
    @required AnimatedListItemBuilder itemBuilder,
    ScrollController controller,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    EdgeInsetsGeometry padding,
    bool shrinkWrap = false,
    ScrollPhysics physics,
  }) {
    GlobalKey<AnimatedListState> _keyOfChild =
        key ?? GlobalKey<AnimatedListState>();
    final child = _OuterAnimatedList(
      itemBuilder: itemBuilder,
      key: _keyOfChild,
      initialItemCount: 5,
      controller: controller ?? ScrollController(),
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      reverse: reverse,
      scrollDirection: scrollDirection,
    );
    final onNotification = (ScrollNotification noti) {
      if (noti is! ScrollUpdateNotification) return;
      final ScrollUpdateNotification noti2 = noti;
      if (noti2.metrics.pixels >= noti2.metrics.maxScrollExtent &&
          noti2.scrollDelta > 0.0) {
        double innerVelocity = max(noti2.scrollDelta * 50, 500);
        innerVelocity = min(innerVelocity, 2000);
        final newVelocity = velocityFunc(noti2.metrics, innerVelocity);
        ScrollPositionWithSingleContext pos = child.controller.position;
        if (!pos.isScrollingNotifier.value) {
          child.goBallistic(newVelocity);
        }
      }
    };
    return OuterList(
      child: child,
      onNotification: onNotification,
    );
  }
}

class _OuterAnimatedList extends AnimatedList {
  _OuterAnimatedList({
    @required AnimatedListItemBuilder itemBuilder,
    Key key,
    int initialItemCount,
    ScrollController controller,
    bool reverse = false,
    EdgeInsetsGeometry padding,
    bool shrinkWrap = false,
    scrollDirection = Axis.vertical,
    ScrollPhysics physics,
  }) : super(
          itemBuilder: itemBuilder,
          key: key,
          initialItemCount: initialItemCount,
          controller: controller,
          padding: padding,
          shrinkWrap: shrinkWrap,
          scrollDirection: scrollDirection,
          physics: physics,
        );
  void goBallistic(double velocity) {
    ScrollPositionWithSingleContext pos = controller.position;
    pos.goBallistic(velocity);
  }
}
