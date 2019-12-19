import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
class InnerList extends ListView {
  InnerList({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary, // Isn't this always false? 
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    itemExtent,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    List<Widget> children = const <Widget>[],
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  }): super(
     key: key,
    scrollDirection: scrollDirection,
    reverse: reverse,
    controller: controller,
    primary: primary,
    physics: physics,
    shrinkWrap: shrinkWrap,
    padding: padding,
    itemExtent: itemExtent,
     addAutomaticKeepAlives: addAutomaticKeepAlives,
     addRepaintBoundaries: addRepaintBoundaries,
     addSemanticIndexes: addSemanticIndexes,
    cacheExtent: cacheExtent,
    children: children,
    semanticChildCount: semanticChildCount,
    dragStartBehavior: dragStartBehavior,
  );
  InnerList.builder({
    Key key,
    Axis scrollDirection = Axis.vertical,
    @required IndexedWidgetBuilder itemBuilder,
    bool reverse = false,
    ScrollController controller,
    bool primary, // Isn't this always false? 
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    itemExtent,
    int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    int semanticChildCount,
    
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
}) : super.builder(

    key: key,
    itemBuilder: itemBuilder,
    itemCount: itemCount,
    scrollDirection: scrollDirection,
    reverse: reverse,
    controller: controller,
    primary: primary,
    physics: physics,
    shrinkWrap: shrinkWrap,
    padding: padding,
    itemExtent: itemExtent,
     addAutomaticKeepAlives: addAutomaticKeepAlives,
     addRepaintBoundaries: addRepaintBoundaries,
     addSemanticIndexes: addSemanticIndexes,
    cacheExtent: cacheExtent,
    semanticChildCount: semanticChildCount,
    dragStartBehavior: dragStartBehavior,
  );

} 
class AnimatedInnerList extends AnimatedList {}  