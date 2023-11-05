import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CallNativeManager {
  static const MethodChannel _channel = MethodChannel("call_native_manager");
  static Future<Image> get imageGeneral async {
    final Image img = await _channel.invokeMethod('imageGeneral');
    return img;
  }
}
