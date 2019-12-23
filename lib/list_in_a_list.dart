import 'package:flutter/material.dart';
import 'package:list_in_a_list/InnerControllers.dart';

typedef InnerListWidgetBuilder = Widget Function(
    int outerIndex, BuildContext context, int innerIndex);
typedef InnerListChildrenBuilder = List<Widget> Function(int outerIndex);
typedef InnerListBuilder = Widget Function(int index, InnerListParam p);
typedef OuterWidgetBuilder = Widget Function(BuildContext context, int index,
    InnerListParam p, InnerListBuilder innerWidget);
typedef VelocityCalculator = double Function(
    ScrollMetrics position, double innerVelocity);
typedef AnimatedListInnerBuilder = Widget Function(
    int outerIndex, BuildContext context, int index, Animation animation);
typedef AnimatedOuterBuilder = Widget Function(BuildContext context, int index,
    AnimatedListParam p, InnerListBuilder innerWidget, Animation animation);
enum InnerListPhysics {
  Bouncing,
  Clamping,
}

class InnerListParam {
   InnerListWidgetBuilder itemBuilder;
   InnerListChildrenBuilder children;
   ScrollController controller;
   InnerListPhysics physics;
   int itemCount;
  InnerListParam(
      {this.physics,
      this.itemBuilder,
      this.children,
      this.controller,
      this.itemCount});
}

class AnimatedListParam extends InnerListParam {
   AnimatedListInnerBuilder animatedItemBuilder;
  AnimatedListParam({
    this.animatedItemBuilder,
    physics,
    children,
    controller,
    itemCount, 
  }) : super(physics: physics, children: children, controller: controller, itemCount: itemCount);
}

/// ListInAList is a class that makes it easy to create a list in a list!
class ListInAList extends ListView {
  ListInAList.builder(
      {IndexedWidgetBuilder itemBuilder, ScrollController controller})
      : super.builder(itemBuilder: itemBuilder, controller: controller);

  factory ListInAList.doubleBuilder(
      {InnerListParam param,
      OuterWidgetBuilder outerBuilder,
      @required VelocityCalculator velocityFunc}) {
    final controller = ScrollController();

    final innerBuilder = (outerIndex, p) =>
        ListInAList.innerListBuilder(outerIndex, p, (position, velocity) {
          ScrollPositionWithSingleContext pos = controller.position;
          // Cast it to remove squiggles. Yeah this way will error when this cease to be the truth. It is fair though!
          double outerVel = velocityFunc(position, velocity);
          if (controller.hasClients) pos.goBallistic(outerVel);
        });
    final itemBuilder =
        (context, index) => outerBuilder(context, index, param, innerBuilder);
    return ListInAList.builder(
      itemBuilder: itemBuilder,
      controller: controller,
    );
  }

  static ListView innerListChildren(
          int outerIndex, InnerListParam p, innerListener) =>
      ListView(
        children: p.children(outerIndex),
        controller: p.controller,
        physics: innerphysics(p.physics, innerListener),
      );
  static ListView innerListBuilder(
          int outerIndex, InnerListParam p, innerListener) =>
      ListView.builder(
          itemBuilder: (context, index) =>
              p.itemBuilder(outerIndex, context, index),
          controller: p.controller,
          itemCount: p.itemCount,
          physics: innerphysics(p.physics, innerListener));
  static ScrollPhysics innerphysics(InnerListPhysics physic,
      void Function(ScrollMetrics, double) innerListener) {
    return (physic == InnerListPhysics.Bouncing)
        ? BouncingInnerListPhysics(physicsListener: innerListener)
        : ClampingInnerListPhysics(physicsListener: innerListener);
  }
}

class AnimatedListInAList extends AnimatedList {
  AnimatedListInAList(
      {AnimatedListItemBuilder itemBuilder, ScrollController controller})
      : super(itemBuilder: itemBuilder, controller: controller);
  factory AnimatedListInAList.doubleBuilder({
    AnimatedListParam param,
    @required AnimatedOuterBuilder outerBuilder,
    @required VelocityCalculator velFunc,
  }) {
    final controller = ScrollController();
    final innerBuilder = (outerIndex, param) =>
        AnimatedListInAList.innerListBuilder(outerIndex, param,
            (position, velocity) {
          ScrollPositionWithSingleContext pos = controller.position;
          double outerVel = velFunc(position, velocity);
          if (controller.hasClients) pos.goBallistic(outerVel);
        });
    AnimatedListItemBuilder itemBuilder = (context, index, animation) =>
        outerBuilder(context, index, param, innerBuilder, animation);
    return AnimatedListInAList(
      itemBuilder: itemBuilder,
      controller: controller,
    );
  }

  static AnimatedList innerListBuilder(
          int outerIndex, AnimatedListParam p, innerListener) =>
      AnimatedList(
        itemBuilder: (BuildContext context, int index, Animation animation) =>
            p.animatedItemBuilder(outerIndex, context, index, animation),
        controller: p.controller ?? ScrollController(),
        physics: ListInAList.innerphysics(p.physics, innerListener),
        initialItemCount: p.itemCount,
      );
}
