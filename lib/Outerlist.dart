import 'package:flutter/material.dart';
import 'ScrollNotification.dart' as ListInAListNoti;

class OuterList
    extends NotificationListener<ListInAListNoti.ScrollNotification> {
  OuterList({child, onNotification}): super(child: child, onNotification: onNotification, );

  factory  OuterList.builder({Key key, AnimatedListItemBuilder itemBuilder, }) { 
     GlobalKey<AnimatedListState> _keyOfChild = key ?? GlobalKey<AnimatedListState>();
    final child = OuterAnimatedList(itemBuilder: itemBuilder, key: _keyOfChild,initialItemCount: 5,controller: ScrollController(),);
    final onNotification = (ListInAListNoti.ScrollNotification noti) { 
      
      if (noti.position.pixels >= noti.position.maxScrollExtent && noti.velocity >=0) { 
        child.goBallistic(noti.velocity);
      }
    };
    return OuterList(child: child, onNotification: onNotification,);
  }
}
class OuterAnimatedList extends AnimatedList { 
OuterAnimatedList({
  @required AnimatedListItemBuilder itemBuilder,
  Key key,
  int initialItemCount,
  ScrollController controller,
}): super(itemBuilder: itemBuilder, key: key, initialItemCount: initialItemCount, controller: controller);
void goBallistic(double velocity) { 
  ScrollPositionWithSingleContext pos = controller.position;
  pos.goBallistic(velocity);
}
}
