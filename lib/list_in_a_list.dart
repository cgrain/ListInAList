import 'package:flutter/material.dart';
import 'package:list_in_a_list/InnerControllers.dart';
import 'package:list_in_a_list/outerControllers.dart';

typedef InnerListWidgetBuilder = Widget Function(
    int outerIndex, BuildContext context, int innerIndex);
typedef InnerListChildrenBuilder = List<Widget> Function(int outerIndex);
typedef InnerListBuilder = Widget Function(int index, InnerListParam p);
typedef OuterWidgetBuilder = Widget Function(BuildContext context, int index,
    InnerListParam p, InnerListBuilder innerWidget);
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
      {IndexedWidgetBuilder itemBuilder, OuterController controller})
      : super.builder(itemBuilder: itemBuilder, controller: controller);


  factory ListInAList.doubleBuilder(
      {InnerListParam param, OuterWidgetBuilder outerBuilder}) {
    final controller = OuterController();
    final innerBuilder = (outerIndex, p) =>
        ListInAList.innerListBuilder(outerIndex, p, controller.moveMe);
    final itemBuilder =
        (context, index) => outerBuilder(context, index, param, innerBuilder);
    return ListInAList.builder(
      itemBuilder: itemBuilder,
      controller: controller,
    );
  }

  // ListInAList.builderAndChildren(
  //     InnerListParam param, OuterWidgetBuilder outerBuilder)
  //     : super.builder(
  //           itemBuilder: (context, index) => outerBuilder(
  //                 context,
  //                 index,
  //                 param,
  //                 (outerIndex, p) => ListInAList.innerListChildren(
  //                     outerIndex, p, controller.moveMe),
  //               ));

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
