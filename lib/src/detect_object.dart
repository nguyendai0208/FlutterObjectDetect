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
  Future<List<Map<String, dynamic>>> detectImage(
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
  Future<List<Map<String, dynamic>>> detectImage(
      {required Uint8List bytesList,
      required int imageHeight,
      required int imageWidth}) {
    // TODO: implement detectImage
    return _vision.yoloOnImage(
        bytesList: bytesList, imageHeight: imageHeight, imageWidth: imageWidth);
    ;
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
  Future<List<Map<String, dynamic>>> detectImage(
      {required Uint8List bytesList,
      required int imageHeight,
      required int imageWidth}) async {
    // TODO: implement detectImage
    var img = bytesList;
    try {
      final channelResp = await _nativeChannel
          .invokeMethod<List<dynamic>>("detect", {'img': img});
      return channelResp?.isNotEmpty ?? false
          ? channelResp!.map((e) => Map<String, dynamic>.from(e)).toList()
          : [];
    } catch (e) {
      rethrow;
    }
  }
}
