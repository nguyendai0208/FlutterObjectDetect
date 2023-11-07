import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_vision/flutter_vision.dart';

abstract class DetectObjectVision {
  factory DetectObjectVision() {
    switch (Platform.operatingSystem) {
      case 'android':
        return AndroidDetectObjectVision();
      case 'ios':
        return IosDetectObjectVision();
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  Future<void> loadModel();
  Future<Map<String, dynamic>> detectImage(
      {required Uint8List bytesList,
      required int imageHeight,
      required int imageWidth});
}

class AndroidDetectObjectVision implements DetectObjectVision {
  final FlutterVision _vision = FlutterVision();

  @override
  Future<void> loadModel() async {
    // TODO: implement loadModel
    return _vision.loadYoloModel(
        labels: 'assets/classes.txt',
        modelPath: 'assets/best_yolov8s_080923_float32.tflite',
        modelVersion: "yolov8",
        quantization: false,
        numThreads: 2,
        useGpu: true);
  }

  @override
  Future<Map<String, dynamic>> detectImage(
      {required Uint8List bytesList,
      required int imageHeight,
      required int imageWidth}) async {
    // TODO: implement detectImage
    var abc = await _vision.yoloOnImage(
        bytesList: bytesList, imageHeight: imageHeight, imageWidth: imageWidth);
    var rs = Map.fromEntries(abc.map((e) => MapEntry(e[0].toString(), e[1])));
    return rs;
  }
}

class IosDetectObjectVision implements DetectObjectVision {
  final MethodChannel _nativeChannel = MethodChannel("call_native_manager");
  @override
  Future<void> loadModel() {
    // TODO: implement loadModel
    return Future.value();
  }

  @override
  Future<Map<String, dynamic>> detectImage(
      {required Uint8List bytesList,
      required int imageHeight,
      required int imageWidth}) async {
    // TODO: implement detectImage
    var img = bytesList;
    try {
      var channelResp =
          await _nativeChannel.invokeMethod("detect", {'img': img});
      var item = Map<String, dynamic>.from(channelResp);
      // final abc = await platform.invokeMethod("detect");
      return item;
    } catch (e) {
      rethrow;
    }
  }
}
