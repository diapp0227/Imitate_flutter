import 'package:flutter/services.dart';

class HelloWorldRepository {
  static const platform = MethodChannel('HelloWorldRepository');

  String fetch() {
    return "Flutter Hello World";
  }

}