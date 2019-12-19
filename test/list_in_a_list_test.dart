import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_in_a_list/list_in_a_list.dart';

void main() {
  const MethodChannel channel = MethodChannel('list_in_a_list');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await ListInAList.platformVersion, '42');
  });
}
