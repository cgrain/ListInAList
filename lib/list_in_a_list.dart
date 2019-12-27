import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:list_in_a_list/InnerControllers.dart';

typedef InnerListWidgetBuilder = Widget Function(
    int outerIndex, BuildContext context, int innerIndex);
typedef InnerListChildrenBuilder = List<Widget> Function(int outerIndex);
typedef InnerListBuilder = Widget Function(
    BuildContext context, int index, InnerListParam p);
typedef OuterWidgetBuilder = Widget Function(BuildContext context, int index,
    InnerListParam p, InnerListBuilder innerWidget);
typedef VelocityCalculator = double Function(
    ScrollMetrics position, double innerVelocity);
typedef AnimatedListInnerBuilder = Widget Function(
    int outerIndex, BuildContext context, int index, Animation animation);
typedef AnimatedOuterBuilder = Widget Function(BuildContext context, int index,
    AnimatedListParam p, InnerListBuilder innerWidget, Animation animation);
enum InnerListPhysics {
  Bouncing,
  Clamping,
}

class InnerListParam {
  InnerListWidgetBuilder itemBuilder;
  InnerListChildrenBuilder children;
  ScrollController controller;
  InnerListPhysics physics;
  int itemCount;

  /// [innerKey] is null in initialization. It makes no sense to create it at initialization because [this] is used
  /// for multiple listViews. Therefore, it should be managed by the outerWidget and potentially edited by the [InnerListBuilder]
  GlobalKey innerKey;

  InnerListParam(
      {this.physics,
      this.itemBuilder,
      this.children,
      this.controller,
      this.itemCount});
}

class AnimatedListParam extends InnerListParam {
  AnimatedListInnerBuilder animatedItemBuilder;
  AnimatedListParam({
    this.animatedItemBuilder,
    physics,
    children,
    controller,
    itemCount,
  }) : super(
            physics: physics,
            children: children,
            controller: controller,
            itemCount: itemCount);
  AnimatedListParam deepCopy() {
    return AnimatedListParam(
      animatedItemBuilder: this.animatedItemBuilder,
      physics: this.physics,
      children: this.children,
      controller: this.controller,
      itemCount: this.itemCount,
    );
  }
}

/// ListInAList is a class that makes it easy to create a list in a list!
class ListInAList extends ListView {
  ListInAList.builder(
      {IndexedWidgetBuilder itemBuilder, ScrollController controller})
      : super.builder(itemBuilder: itemBuilder, controller: controller);

  factory ListInAList.doubleBuilder(
      {InnerListParam param,
      OuterWidgetBuilder outerBuilder,
      @required VelocityCalculator velocityFunc}) {
    final controller = ScrollController();

    final innerBuilder = (context, outerIndex, p) =>
        ListInAList.innerListBuilder(outerIndex, p, (position, velocity) {
          ScrollPositionWithSingleContext pos = controller.position;
          // Cast it to remove squiggles. Yeah this way will error when this cease to be the truth. It is fair though!
          double outerVel = velocityFunc(position, velocity);
          if (controller.hasClients) pos.goBallistic(outerVel);
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

class AnimatedListInAList extends AnimatedList {
  /// When Dart updates, Update this to se we can use a typedef! i.e.
  /// typedef MapOfKeys = Map<int,GlobalKey<AnimatedListState>>;
  final Map<int, GlobalKey<AnimatedListState>> keys;
  VelocityCalculator velFunc;
  AnimatedOuterBuilder outerBuilder;
  AnimatedListParam param;
  AnimatedListInAList(
      {AnimatedListItemBuilder itemBuilder,
      @required  this.outerBuilder,
      OuterScroll controller,
      int initialItemCount,
      Map keys, this.velFunc, this.param})
      : keys = keys ?? Map(),
        super(
            itemBuilder: (_,__,___) => null, //THIS IS OVERRIDDEN
            controller: controller,
            initialItemCount: initialItemCount);
  factory AnimatedListInAList.doubleBuilder({
    @required AnimatedListParam param,
    @required AnimatedOuterBuilder outerBuilder,
    @required VelocityCalculator velFuncNew,
    Map<int, GlobalKey<AnimatedListState>> keys,
    initialCount,
  }) {
    param = param ?? AnimatedListParam();
    keys = keys ?? Map<int, GlobalKey<AnimatedListState>>();
    final controller = OuterScroll();
    return AnimatedListInAList(
      itemBuilder: null,
      outerBuilder: outerBuilder,
      controller: controller,
      initialItemCount: 5,
      keys: keys,
      velFunc: velFuncNew,
      param: param,
    );
    
  }
  
  OuterScroll controlNew() => controller;
  void goBallistic(velocity) => controlNew().goBallistic(velocity);
  @override
  get itemBuilder => (context, index, animation) { 
    final newParam = param.deepCopy();
    print('BUILDING: ${controller.hashCode}');
    final innerBuilder = (BuildContext context,int outerIndex, InnerListParam paramNew, {Key newKey} ) => 
    AnimatedListInAList.innerListBuilder(outerIndex, paramNew, keys,
            (position, velocity) {
          double outerVel = velFunc(position, velocity);
         goBallistic(outerVel);
        }, newKey: newKey);
    return outerBuilder(context, index, newParam,innerBuilder,animation );
    };
    
  
  static AnimatedList innerListBuilder(int outerIndex, AnimatedListParam p,
      Map<int, dynamic> keys, innerListener,
      {Key newKey}) {
    if (newKey != null) keys[outerIndex] = newKey;
    final key = newKey ??
        keys.putIfAbsent(outerIndex, () => GlobalKey<AnimatedListState>());
    return AnimatedList(
        key: key,
        itemBuilder: (BuildContext context, int index, Animation animation) =>
            p.animatedItemBuilder(outerIndex, context, index, animation),
        controller: p.controller ?? ScrollController(),
        physics: ListInAList.innerphysics(p.physics, innerListener),
        initialItemCount: p.itemCount);
  }
  void listener(ScrollMetrics position, double velocity) { 
    ScrollPositionWithSingleContext pos = controller.position;
    final newVel = velFunc(position,velocity);
    pos.goBallistic(newVel);
  }
}
class OuterScroll extends ScrollController { 
  void goBallistic(double velocity) { 
    print('Go Ballistic: $hashCode');
    if (!hasClients) return;
    ScrollPositionWithSingleContext pos = position;
pos.goBallistic(velocity);  }

@override 
void detach(ScrollPosition position) {
    print("I am detaching!: $hashCode");
    // TODO: implement detach
    super.detach(position);
  }
  @override 
  void dispose() {
    print('I am disposed!: $hashCode');
    // TODO: implement dispose
    super.dispose();
  }
  @override 
  void attach(ScrollPosition position) {
    print("ATTACHING: $hashCode");
    // TODO: implement attach
    super.attach(position);
  }
  OuterScroll() : super() { 
    print("CREATING: $hashCode");
    
  }
}