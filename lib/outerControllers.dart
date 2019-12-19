
import 'package:flutter/material.dart';

class OuterController extends ScrollController { 
@override
  ScrollPosition createScrollPosition(ScrollPhysics physics,
      ScrollContext context, ScrollPosition oldPosition) {
    return OuterPosition(
        physics: physics, context: context, oldPosition: oldPosition);
  }

  void moveMe(velocity) {
    OuterPosition _customPosition = position;
    _customPosition.moveMe(velocity);
  }
}
class OuterPosition extends ScrollPositionWithSingleContext { 
OuterPosition({
    physics,
    context,
    oldPosition,
  }) : super(physics: physics, context: context, oldPosition: oldPosition);
  void moveMe(velocity) {
    final sim = physics.createBallisticSimulation(this, velocity);
    if (sim != null) {
      ScrollActivity _activity =
          BallisticScrollActivity(activity.delegate, sim, context.vsync);
      beginActivity(_activity);
    }
  }
}