import 'package:flutter/material.dart';

class ScrollNotification extends Notification { 
  ScrollMetrics position;
  double velocity;
  ScrollNotification({this.position, this.velocity});
}