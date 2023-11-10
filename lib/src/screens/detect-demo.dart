import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/controls/button.dart';
import 'package:flutter_application_1/src/constants/image.dart';
import 'package:flutter_application_1/src/detect_object.dart';
import 'package:flutter_application_1/src/models/detect-model.dart';
import 'package:flutter_application_1/src/widgets/detech-result.dart';
import 'package:image_picker/image_picker.dart';
import "package:collection/collection.dart";

class DetectDemoPage extends StatefulWidget {
  const DetectDemoPage({super.key});

  @override
  State<DetectDemoPage> createState() => _DetectDemoPageState();
}

class _DetectDemoPageState extends State<DetectDemoPage> {
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  List<Map<String, dynamic>> listDetect = [];
  Map<String, DetectModel> mapDetech = {};
  int imageHeight = 1;
  int imageWidth = 1;

  bool isLoaded = false;
  bool isDetect = false;

  Map<dynamic, int> xx = {};
  final DetectObjectVision _detectObjectManager = DetectObjectVision();

  @override
  void initState() {
    super.initState();
    _detectObjectManager.loadModel();
  }

  _setFile(file) {
    if (file != null) {
      setState(() {
        imageFile = File(file.path);
        isDetect = false;
        listDetect = [];
        mapDetech = {};
      });
    }
  }

  onSelectImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    _setFile(file);
  }

  onTakePhoto() async {
    final XFile? file = await picker.pickImage(source: ImageSource.camera);
    _setFile(file);
  }

  Future<void> _getObjectDetect() async {
    Map<String, DetectModel> mapGroupTag = {};
    // var data = await rootBundle.load("assets/images/demo-camera.jpg");
    // var img = data.buffer.asUint8List();
    Uint8List img = imageFile!.readAsBytesSync();
    var image = await decodeImageFromList(img);
    imageHeight = image.height;
    imageWidth = image.width;

    try {
      final result = await _detectObjectManager.detectImage(
          bytesList: img, imageHeight: image.height, imageWidth: image.width);

      if (result.isNotEmpty) {
        mapGroupTag = groupBy(result, (obj) => obj['tag'])
            .map((key, value) => MapEntry(key as String, DetectModel(category: key, count: value.length, color: Colors.primaries[Random().nextInt(Colors.primaries.length)])));
      }
      setState(() {
        mapDetech = mapGroupTag;
        listDetect = result;
        isDetect = true;
      });
    } on PlatformException {
      print("ERR");
    }
  }

  Widget renderImageDefault(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (imageFile != null) {
      return Image.file(
        File(imageFile!.path),
      );
      // return Image.asset(
      //   'assets/images/demo-camera.jpg',
      // );
    }
    return Image.asset(
      ImageConst.uploadIcon,
      height: width,
      width: double.infinity,
    );
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (listDetect.isEmpty) return [];

    double factorX = screen.width / (imageWidth);
    double imgRatio = imageWidth / imageHeight;
    double newWidth = imageWidth * factorX;
    double newHeight = newWidth / imgRatio;
    double factorY = newHeight / (imageHeight);

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);
    return listDetect.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: mapDetech[result['tag']]!.color, width: 2.0),
          ),
          child: Text(
            "",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardTheme.color,
          title: const Text('Detech Demo'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Stack(
              children: [
                renderImageDefault(context),
                ...displayBoxesAroundRecognizedObjects(size),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                DefaultButton(
                  text: 'Select Image',
                  minimumSize: const Size.fromHeight(50),
                  radius: 20,
                  background: Colors.blue,
                  onPress: () => onSelectImage(),
                ),
                const SizedBox(
                  height: 10,
                ),
                DefaultButton(
                    text: 'Take Photo',
                    minimumSize: const Size.fromHeight(50),
                    radius: 20,
                    background: Colors.blue,
                    onPress: () => onTakePhoto()),
                const SizedBox(
                  height: 10,
                ),
                DefaultButton(
                  text: 'Perform Object Detecttion',
                  minimumSize: const Size.fromHeight(50),
                  radius: 20,
                  background: imageFile != null && !isDetect
                      ? Colors.blue
                      : Colors.grey,
                  onPress: () => {
                    if (imageFile != null && !isDetect) {_getObjectDetect()}
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                // Text('Success(Total: 7578ms - Model: 3110 ms)')
              ]),
            ),
            if (mapDetech.isEmpty && isDetect) const Text('Not found data!'),
            if (mapDetech.isNotEmpty) DetectCategories(categories: mapDetech)
          ]),
        ));
  }
}
