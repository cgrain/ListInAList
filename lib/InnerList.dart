import 'package:flutter/material.dart';
import 'ScrollNotification.dart' as ListInAList;
class AnimatedInnerList extends AnimatedList {
  AnimatedInnerList(
      {Key key,
      AnimatedListItemBuilder itemBuilder,
      int initialItemCount,
      @required BuildContext context})
      : super(
            key: key,
            itemBuilder: itemBuilder,
            initialItemCount: initialItemCount,
            physics: NewInnerPhysics(context: context));
  @override
// TODO: implement itemBuilder
  get itemBuilder => (xx, yy, zz) => super.itemBuilder(xx, yy, zz);
}

class NewInnerPhysics extends BouncingScrollPhysics {
  BuildContext context;
  NewInnerPhysics({this.context}): super();
  @override 
  BouncingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return NewInnerPhysics(context: context);
  }
  @override 
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    ListInAList.ScrollNotification _noti = ListInAList.ScrollNotification(position: position, velocity:velocity);
    _noti..dispatch(context);
    return super.createBallisticSimulation(position, velocity);
  }
}
