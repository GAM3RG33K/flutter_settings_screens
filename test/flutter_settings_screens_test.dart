//import 'package:flutter/services.dart';
//import 'package:flutter_test/flutter_test.dart';
//import 'package:flutter_settings_screens/flutter_settings_screens.dart';
//
//void main() {
//  const MethodChannel channel = MethodChannel('flutter_settings_screens');
//
//  TestWidgetsFlutterBinding.ensureInitialized();
//
//  setUp(() {
//    channel.setMockMethodCallHandler((MethodCall methodCall) async {
//      return '42';
//    });
//  });
//
//  tearDown(() {
//    channel.setMockMethodCallHandler(null);
//  });
//
//  test('getPlatformVersion', () async {
//    expect(await FlutterSettingsScreens.platformVersion, '42');
//  });
//}
