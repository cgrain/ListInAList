import 'package:flutter/material.dart';

/// ListInAList is a class that makes it easy to create a list in a list!
class ListInAList extends ListView{
  ListInAList(): super();
  ListInAList.builder({IndexedWidgetBuilder itemBuilder}): super.builder(itemBuilder: itemBuilder);
  ListInAList.doubleBuilder();
  ListInAList.builderAndChildren();
  ListInAList.childrenAndbuilder(); 
  ListInAList.doublechildren();

}
class ListInAListMixin {} 

class AnimatedListInAList extends AnimatedList with ListInAListMixin {
  AnimatedListInAList({AnimatedListItemBuilder itemBuilder}): super(itemBuilder: itemBuilder);
  AnimatedListInAList.doubleBuilder();
}
