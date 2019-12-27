import 'package:flutter/material.dart';
enum InnerListPhysics { BOUNCING, CLAMPING }

class AnimatedInnerList extends AnimatedList {
  AnimatedInnerList(
      {Key key,
      AnimatedListItemBuilder itemBuilder,
      int initialItemCount,
      InnerListPhysics physics = InnerListPhysics.BOUNCING,
      scrollDirection = Axis.vertical,
      bool reverse = false,
      ScrollController controller,
      EdgeInsetsGeometry padding, 
      bool shrinkWrap = false,
      @required BuildContext context})
      : super(
            key: key,
            itemBuilder: itemBuilder,
            initialItemCount: initialItemCount,
            physics: (physics == InnerListPhysics.BOUNCING)
                ? BouncingScrollPhysics()
                : ClampingScrollPhysics(),
                scrollDirection: scrollDirection,
                reverse: reverse,
                controller: controller,
                padding: padding,
                shrinkWrap: shrinkWrap,
                );
}
