import 'package:flutter/services.dart';

class HelloWorldRepository {
  static const platform = MethodChannel('HelloWorldRepository');

  void registerMethodHandler() {
    platform.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'fetch':
        // ネイティブから呼び出されたメソッドの実装
          return fetch();
        default:
          throw PlatformException(code: 'Unimplemented');
      }
    });
  }

  String fetch() {
    return "Flutter Hello World";
  }

}