import 'package:flutter/cupertino.dart';

/// I do not need to control 
class _InnerListController extends ScrollController { 
  
}
/// Obviously, one would expect that a mixin Should work much and much better, because we are copying code. However, 
/// I do not know how to design that in such a way, 
/// So I put this here so everybody stays we reminded we could one day do that better.
abstract class _InnerListPhysicsMixin extends ScrollPhysics { 
  final void Function(ScrollMetrics, double) physicsListener;

  _InnerListPhysicsMixin(this.physicsListener);

}

class BouncingInnerListPhysics extends BouncingScrollPhysics { 
  final void Function(ScrollMetrics position, double velocity) physicsListener;
BouncingInnerListPhysics({this.physicsListener, ScrollPhysics parent})
      : super(parent: parent);
  @override
  BouncingInnerListPhysics applyTo(ScrollPhysics ancestor) {
    return BouncingInnerListPhysics(
        physicsListener: physicsListener, parent: buildParent(ancestor));
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (position.pixels >= position.maxScrollExtent && velocity >= 0.0) {
      physicsListener(position, velocity);
    }
    return super.createBallisticSimulation(position, velocity);
  }
}
class ClampingInnerListPhysics extends ClampingScrollPhysics  { 
  final void Function(ScrollMetrics position, double velocity) physicsListener;
ClampingInnerListPhysics({this.physicsListener, ScrollPhysics parent})
      : super(parent: parent);
  @override
  ClampingInnerListPhysics applyTo(ScrollPhysics ancestor) {
    return ClampingInnerListPhysics(
        physicsListener: physicsListener, parent: buildParent(ancestor));
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (position.pixels >= position.maxScrollExtent && velocity >= 0.0) {
      physicsListener(position, velocity);
    }
    return super.createBallisticSimulation(position, velocity);
  }
}
