
import 'package:flutter/material.dart';

class OuterController extends ScrollController { 
@override
  OuterPosition createScrollPosition(ScrollPhysics physics,
      ScrollContext context, ScrollPosition oldPosition) {
    return OuterPosition(
        physics: physics, context: context, oldPosition: oldPosition);
  }

  void moveMe(ScrollMetrics positionInner, double velocity) {
    
    print('TEST');
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
    print('TEST2');
    goBallistic(velocity);
    //final sim = physics.createBallisticSimulation(this, velocity);
    //if (sim != null) {
    //  ScrollActivity _activity =
    //      BallisticScrollActivity(activity.delegate, sim, context.vsync);
    //  beginActivity(_activity);
    //}
  }
}