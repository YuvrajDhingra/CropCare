// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite/tflite.dart';

// class Tflite extends StatefulWidget {
//   const Tflite({super.key});

//   @override
//   State<Tflite> createState() => _TfliteState();
// }

// class _TfliteState extends State<Tflite> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     loadModel();
//   }

//   Future loadModel() async {
//     await Tflite.close();
//     String res;
//     res = await Tflite.loadModel(model: "assets/tf_lite_model.tflite");
//     print("model loading status :$res");
//   }
//   Future imageClassification(File Image) async {
//     var recognitions = await Tflite.runModelOnImage(
//   path: Image.path,   // required
//   imageMean: 0.0,   // defaults to 117.0
//   imageStd: 255.0,  // defaults to 1.0
//   numResults: 2,    // defaults to 5
//   threshold: 0.2,   // defaults to 0.1
//   asynch: true      // defaults to true
// );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("imageClassification"),
//       ),
//       body: ListView(
//         children: [],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: pickImage,
//         tooltip: "pick Image",
//         child: Icon(Icons.image),
//       ),
//     );
//   }

//   Future pickImage() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//     );
//     File Image = File(pickedFile!.path);
//     imageClassification()
//   }
// }



import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class TfliteModel extends StatefulWidget {
  const TfliteModel({Key? key}) : super(key: key);

  @override
  _TfliteModelState createState() => _TfliteModelState();
}

class _TfliteModelState extends State<TfliteModel> {
  
  late File _image;
  late List _results;
  bool imageSelect=false;
  @override
  void initState()
  {
    super.initState();
    loadModel();
  }
  Future loadModel()
  async {
    Tflite.close();
    String res;
    res=(await Tflite.loadModel(model: "assets/if_lite_model.tflite"))!;
    print("Models loading status: $res");
  }

  Future imageClassification(File image)
  async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results=recognitions!;
      _image=image;
      imageSelect=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Classification"),
      ),
      body: ListView(
        children: [
          (imageSelect)?Container(
        margin: const EdgeInsets.all(10),
        child: Image.file(_image),
      ):Container(
        margin: const EdgeInsets.all(10),
            child: const Opacity(
              opacity: 0.8,
              child: Center(
                child: Text("No image selected"),
              ),
            ),
      ),
          SingleChildScrollView(
            child: Column(
              children: (imageSelect)?_results.map((result) {
                return Card(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "${result['label']} - ${result['confidence'].toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.red,
                      fontSize: 20),
                    ),
                  ),
                );
              }).toList():[],

            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        tooltip: "Pick Image",
        child: const Icon(Icons.image),
      ),
    );
  }
  Future pickImage()
  async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    File image=File(pickedFile!.path);
    imageClassification(image);
  }
}