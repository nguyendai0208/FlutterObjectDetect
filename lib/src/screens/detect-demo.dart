import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/controls/button.dart';
import 'package:flutter_application_1/src/constants/image.dart';
import 'package:flutter_application_1/src/detect_object.dart';
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
  List<MapEntry<dynamic, int>> yoloResult = [];
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
    yoloResult.clear();
    List<MapEntry<dynamic, int>> results = [];
    var data = await rootBundle.load("assets/images/demo-camera.jpg");
    var img = data.buffer.asUint8List();
    // Uint8List img = imageFile!.readAsBytesSync();
    var image = await decodeImageFromList(img);

    try {
      final result = await _detectObjectManager.detectImage(
          bytesList: img, imageHeight: image.height, imageWidth: image.width);
      if (result.isNotEmpty) {
        results = groupBy(result, (obj) => obj['tag'])
            .map((key, value) => MapEntry(key, value.length))
            .entries
            .map((e) => MapEntry(e.key, e.value))
            .toList();
      }
      setState(() {
        yoloResult = results;
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
        fit: BoxFit.fill,
        height: width,
        width: double.infinity,
      );
    }
    return Image.asset(
      ImageConst.uploadIcon,
      height: width,
      width: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardTheme.color,
          title: const Text('Detech Demo'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            renderImageDefault(context),
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
                  background: !isDetect ? Colors.blue : Colors.grey,
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
            if (yoloResult.isEmpty && isDetect)
            const Text('Not found data!'),
            if (yoloResult.isNotEmpty)
              DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          '#',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Category',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Count',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ],
                  rows: yoloResult.mapIndexed((index, e) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text('$index')),
                        DataCell(Text('${e.key ?? ''}')),
                        DataCell(Text('${e.value}')),
                      ],
                    );
                  }).toList())
          ]),
        ));
  }
}
