import 'package:flutter/material.dart';
import 'package:list_in_a_list/InnerList.dart';

typedef InnerListWidgetBuilder = Widget Function(
    int outerIndex, BuildContext context, int innerIndex);
typedef InnerListChildrenBuilder = List<Widget> Function(int outerIndex);
typedef OuterWidgetBuilder = Widget Function(
    BuildContext context, int index, Widget Function(int index, InnerListParam p) innerWidget);

class InnerListParam {
  InnerListWidgetBuilder itemBuilder;
  InnerListChildrenBuilder children;
  ScrollController controller;
}

/// ListInAList is a class that makes it easy to create a list in a list!
class ListInAList extends ListView {
  ListInAList() : super();
  ListInAList.builder({@required IndexedWidgetBuilder itemBuilder})
      : super.builder(itemBuilder: itemBuilder);
  ListInAList.doubleBuilder(
      InnerListParam param, OuterWidgetBuilder outerBuilder)
      : super.builder(
          itemBuilder: (context, index) => outerBuilder(
              context, index, ListInAList.innerListBuilder,
        ));
  ListInAList.builderAndChildren(
      InnerListParam param, OuterWidgetBuilder outerBuilder)
      : super.builder(
          itemBuilder: (context, index) => outerBuilder(
              context, index, ListInAList.innerListChildren,
        ));

  static InnerList innerListChildren(int outerIndex, InnerListParam p) =>
      InnerList(
        children: p.children(outerIndex),
        controller: p.controller,
      );
  static InnerList innerListBuilder(int outerIndex, InnerListParam p) =>
      InnerList.builder(
        itemBuilder: (context, index) =>
            p.itemBuilder(outerIndex, context, index),
        controller: p.controller,
      );
}

class ListInAListMixin {}

class AnimatedListInAList extends AnimatedList with ListInAListMixin {
  AnimatedListInAList({AnimatedListItemBuilder itemBuilder})
      : super(itemBuilder: itemBuilder);
  AnimatedListInAList.doubleBuilder();
}
