import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_1/src/detect_object.dart';
import 'package:flutter_application_1/src/screens/detect-demo.dart';
import 'package:flutter_application_1/src/yolo_image_v8.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

enum Options { none, imagev5, imagev8, imagev8seg, frame, tesseract, vision }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const DetectDemoPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Image? _imageRender;
  static const platform = MethodChannel("call_native_manager");
  // static const _detectObjectManager = DetectObjectVision();
  final DetectObjectVision _detectObjectManager = DetectObjectVision();
  Options option = Options.none;

  @override
  void initState() {
    super.initState();
    _detectObjectManager.loadModel();
  }

  Widget _imageRenderWidget() {
    if (_imageRender != null) {
      return Container(
        width: 150,
        height: 150,
        decoration:
            BoxDecoration(image: DecorationImage(image: _imageRender!.image)),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoloImageV8(vision: _detectObjectManager),
    );
  }
}
