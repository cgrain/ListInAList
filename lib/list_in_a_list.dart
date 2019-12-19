import 'dart:async';

import 'package:flutter/services.dart';

class ListInAList {
  static const MethodChannel _channel =
      const MethodChannel('list_in_a_list');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
