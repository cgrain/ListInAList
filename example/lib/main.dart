import 'package:flutter/material.dart';
import 'package:list_in_a_list/list_in_a_list.dart';
import 'package:list_in_a_list/OuterList.dart';
import 'package:list_in_a_list/InnerList.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List widgetList;
  @override
  void initState() {
    super.initState();
    widgetList = List();
    for (int i = 0; i < 20; i++) {
      widgetList.add(Container(
          height: 30, color: ((i % 2) == 0) ? Colors.blue : Colors.yellow));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          //final firstKey = keys[0];
                          //widgetList.removeAt(2);
                          //firstKey.currentState.removeItem(2, (_, _test) { return Container(height:30,color: Colors.white);} );
                          setState(() {
                            
                          });
                        },
                      ),
                    )),
                Expanded(
            child: OuterList.builder(itemBuilder: outerItembuilder))
            ])
            ));
  }

  Widget outerItembuilder(context, index, animation) {
    return Column(children: <Widget>[
      Container(
        height: 100,
        color: Colors.red,
      ),
      Container(
        height: 300,
        color: Colors.green,
        child: AnimatedInnerList(
          context: context,
          itemBuilder: innerItembuilder,
          initialItemCount: 15,
        ),
      )
    ]);
  }

  Widget innerItembuilder(context, index, animation) {
    return widgetList[(index) % widgetList.length];
  }
}
