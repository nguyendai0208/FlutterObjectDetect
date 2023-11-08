import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_1/src/detect_object.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  // static const nativePlatform = BasicMessageChannel<dynamic>(
  // "call_native_manager", StandardMessageCodec());
  // Future<void> _getObjectDetect() async {
  //   // const inputImg = Image(image: AssetImage('assets/image-1.png'));
  //   // var data = await rootBundle.load("assets/image-1.png");
  //   var data = await rootBundle.load("assets/images/demo-camera.jpg");
  //   var img = data.buffer.asUint8List();
  //   try {
  //     var channelResp = await platform.invokeMethod("detect", {'img': img});
  //     var item = Map<String, dynamic>.from(channelResp);
  //     // final abc = await platform.invokeMethod("detect");
  //     var imageData = item['img'];
  //     var image = Image.memory(imageData);
  //     setState(() {
  //       _imageRender = image;
  //     });
  //     log("Neo $item");
  //   } on PlatformException {
  //     log("Neo errr");
  //   }
  // }
  // Future<void> _getObjectDetect() async {
  //   // const inputImg = Image(image: AssetImage('assets/image-1.png'));
  //   // var data = await rootBundle.load("assets/image-1.png");
  //   var data = await rootBundle.load("assets/images/demo-camera.jpg");
  //   var img = data.buffer.asUint8List();
  //   try {
  //     // var channelResp = await platform.invokeMethod("detect", {'img': img});
  //     // var item = Map<String, dynamic>.from(channelResp);
  //     // var channelResp = await _detectObjectManager.detectImage(
  //     // bytesList: img, imageHeight: 100, imageWidth: 100);
  //     // final abc = await platform.invokeMethod("detect");
  //     // var item = Map<String, dynamic>.from(channelResp);
  //     var item = await _detectObjectManager.detectImage(
  //         bytesList: img, imageHeight: 100, imageWidth: 100);
  //     var imageData = item['img'];
  //     var image = Image.memory(imageData);
  //     setState(() {
  //       _imageRender = image;
  //     });
  //     log("Neo $item");
  //   } on PlatformException {
  //     log("Neo errr");
  //   }
  // }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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

  // @override
  // Widget build(BuildContext context) {
  //   // This method is rerun every time setState is called, for instance as done
  //   // by the _incrementCounter method above.
  //   //
  //   // The Flutter framework has been optimized to make rerunning build methods
  //   // fast, so that you can just rebuild anything that needs updating rather
  //   // than having to individually change instances of widgets.
  //   return Scaffold(
  //     appBar: AppBar(
  //       // TRY THIS: Try changing the color here to a specific color (to
  //       // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
  //       // change color while the other colors stay the same.
  //       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  //       // Here we take the value from the MyHomePage object that was created by
  //       // the App.build method, and use it to set our appbar title.
  //       title: Text(widget.title),
  //     ),
  //     body: Center(
  //       // Center is a layout widget. It takes a single child and positions it
  //       // in the middle of the parent.
  //       child: Column(
  //         // Column is also a layout widget. It takes a list of children and
  //         // arranges them vertically. By default, it sizes itself to fit its
  //         // children horizontally, and tries to be as tall as its parent.
  //         //
  //         // Column has various properties to control how it sizes itself and
  //         // how it positions its children. Here we use mainAxisAlignment to
  //         // center the children vertically; the main axis here is the vertical
  //         // axis because Columns are vertical (the cross axis would be
  //         // horizontal).
  //         //
  //         // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
  //         // action in the IDE, or press "p" in the console), to see the
  //         // wireframe for each widget.
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           const Text(
  //             'You have pushed the button this many times:',
  //           ),
  //           Text(
  //             '$_counter',
  //             style: Theme.of(context).textTheme.headlineMedium,
  //           ),
  //           const Image(
  //             // image: AssetImage('assets/image-1.png'),
  //             image: AssetImage('assets/images/demo-camera.jpg'),
  //             width: 150,
  //             height: 150,
  //           ),
  //           const Text('222555'),
  //           ElevatedButton(
  //               child: const Text('Hello'), onPressed: _getObjectDetect),

  //           // ElevatedButton(
  //           //   child: Text('Hello'),
  //           //   onPressed: _getObjectDetect(AssetImage('assets/image-1.png')),
  //           // )
  //           // Image(
  //           //   image: DecorationImage(image: _imageRender!s.image),
  //           //   width: 150,
  //           //   height: 150,
  //           // ),
  //           _imageRenderWidget(),
  //         ],
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: _incrementCounter,
  //       tooltip: 'Increment',
  //       child: const Icon(Icons.add),
  //     ), // This trailing comma makes auto-formatting nicer for build methods.
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoloImageV8(vision: _detectObjectManager),
      floatingActionButton: SpeedDial(
        //margin bottom
        icon: Icons.menu, //icon on Floating action button
        activeIcon: Icons.close, //icon when menu is expanded on button
        backgroundColor: Colors.black12, //background color of button
        foregroundColor: Colors.white, //font color, icon color in button
        activeBackgroundColor:
            Colors.deepPurpleAccent, //background color when menu is expanded
        activeForegroundColor: Colors.white,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        buttonSize: const Size(56.0, 56.0),
        children: [
          SpeedDialChild(
            //speed dial child
            child: const Icon(Icons.video_call),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Yolo on Frame',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                option = Options.frame;
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.camera),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'YoloV8seg on Image',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                option = Options.imagev8seg;
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.camera),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'YoloV8 on Image',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                option = Options.imagev8;
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.camera),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'YoloV5 on Image',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                option = Options.imagev5;
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.text_snippet_outlined),
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            label: 'Tesseract',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                option = Options.tesseract;
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.document_scanner),
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            label: 'Vision',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                option = Options.vision;
              });
            },
          ),
        ],
      ),
    );
  }
}
