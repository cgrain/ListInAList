import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:list_in_a_list/list_in_a_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Widget innerWidgetBuilder(
      int outerIndex, BuildContext context, int innerindex) {
    return Container(
        height: 30,
        color:
            ((outerIndex + innerindex) % 2 == 0) ? Colors.blue : Colors.yellow);
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
          child: innerWidgetFunction(index, param),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
        ),
      ),
    );
  }
}
