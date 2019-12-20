import 'package:flutter/material.dart';
import 'package:list_in_a_list/InnerControllers.dart';

typedef InnerListWidgetBuilder = Widget Function(
    int outerIndex, BuildContext context, int innerIndex);
typedef InnerListChildrenBuilder = List<Widget> Function(int outerIndex);
typedef InnerListBuilder = Widget Function(int index, InnerListParam p);
typedef OuterWidgetBuilder = Widget Function(BuildContext context, int index,
    InnerListParam p, InnerListBuilder innerWidget);
  typedef VelocityCalculator = double Function(ScrollMetrics position, double innerVelocity); 

enum InnerListPhysics {
  Bouncing,
  Clamping,
}

class InnerListParam {
  final InnerListWidgetBuilder itemBuilder;
  final InnerListChildrenBuilder children;
  final ScrollController controller;
  final InnerListPhysics physics;
  final int itemCount;
  InnerListParam(
      {this.physics,
      this.itemBuilder,
      this.children,
      this.controller,
      this.itemCount});
}

/// ListInAList is a class that makes it easy to create a list in a list!
class ListInAList extends ListView {



  ListInAList.builder(
      {IndexedWidgetBuilder itemBuilder, ScrollController controller})
      : super.builder(itemBuilder: itemBuilder, controller: controller);


  factory ListInAList.doubleBuilder(
      {InnerListParam param, OuterWidgetBuilder outerBuilder, @required VelocityCalculator velocityFunc}) {
    final controller = ScrollController();
    
    final innerBuilder = (outerIndex, p) =>
        ListInAList.innerListBuilder(outerIndex, p, (position, velocity) {
          ScrollPositionWithSingleContext pos = controller.position; 
          // Cast it to remove squiggles. Yeah this way will error when this cease to be the truth. It is fair though!
          double outerVel = velocityFunc(position, velocity); 
           pos.goBallistic(outerVel);
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

class ListInAListMixin {}

class AnimatedListInAList extends AnimatedList with ListInAListMixin {
  AnimatedListInAList({AnimatedListItemBuilder itemBuilder})
      : super(itemBuilder: itemBuilder);
  AnimatedListInAList.doubleBuilder();
}
