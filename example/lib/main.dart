import 'package:flutter/material.dart';
import 'package:list_in_a_list/list_in_a_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final keys = Map<int, GlobalKey<AnimatedListState>>();
  List widgetList;
  @override
  void initState() {
    widgetList = List();
    for (int i = 0; i < 20; i++) {
      widgetList.add(Container(
          height: 30, color: ((i % 2) == 0) ? Colors.blue : Colors.yellow));
    }

    super.initState();
  }

  double velocityFunc(ScrollMetrics position, double innerVel) {
    return (position.pixels - position.maxScrollExtent) + innerVel / 2.0;
  }

  Widget innerWidgetBuilder(
      int outerIndex, BuildContext context, int innerindex) {
    return widgetList[(outerIndex + innerindex) % widgetList.length];
  }

  Widget outerWidgetBuilder(BuildContext context, int index, param,
      InnerListBuilder innerWidgetFunction) {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          color: Colors.red,
        ),
        Container(
          height: 300,
          child: innerWidgetFunction(context, index, param),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildAnimated(context);
    final p = InnerListParam(
      itemBuilder: innerWidgetBuilder,
      physics: InnerListPhysics.Bouncing,
      itemCount: 20,
    );
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListInAList.doubleBuilder(
          param: p,
          outerBuilder: outerWidgetBuilder,
          velocityFunc: velocityFunc,
        ),
      ),
    );
  }

  Widget buildAnimated(BuildContext context) {
    final p = AnimatedListParam(
        animatedItemBuilder: innerAnimatedWidgetBuilder,
        physics: InnerListPhysics.Bouncing,
        itemCount: 15);
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Animated test app'),
            ),
            body: Column(
              children: <Widget>[
                Container(
                    height: 100,
                    color: Colors.grey,
                    child: Center(
                      child: FlatButton(
                        color: Colors.white60,
                        child: Text('New Item'),
                        onPressed: () {
                          final firstKey = keys[0];
                          widgetList.removeAt(2);
                          firstKey.currentState.removeItem(2, (_, _test) { return Container(height:30,color: Colors.white);} );
                          setState(() {
                            
                          });
                        },
                      ),
                    )),
                Expanded(
                    child: AnimatedListInAList.doubleBuilder(
                  outerBuilder: outerAnimatedWidget,
                  velFunc: velocityFunc,
                  param: p,
                  keys: keys,
                )),
              ],
            )));
  }

  Widget innerAnimatedWidgetBuilder(int outerIndex, BuildContext context,
      int innerIndex, Animation animation) {
    return innerWidgetBuilder(outerIndex, context, innerIndex);
  }

  Widget outerAnimatedWidget(BuildContext context, int outerIndex,
      AnimatedListParam p, InnerListBuilder innerBuilder, Animation animation) {
    return Column(children: <Widget>[
      Container(
        height: 100,
        color: Colors.red,
      ),
      Container(
          height: 300,
          color: Colors.green,
          child: DraggableScrollableSheet(
            initialChildSize: 0.3,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              p.controller = scrollController;
              return innerBuilder(context, outerIndex, p);
            },
          ))
    ]);
  }
}
