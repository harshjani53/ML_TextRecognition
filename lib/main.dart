// ignore_for_file: prefer_const_constructors
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Recognition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Text Recognition'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late File selectImage;
  bool noImage = true;
  final ImagePicker imagePicker = ImagePicker();
  String dataWrite = "";
  String paths = " ";

  Future takeImage() async{
    var store = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
     selectImage = File(store!.path);
     paths = selectImage.path.toString();
     noImage = false;
   });
  }

  Future writeText() async{
    final inputImage = await InputImage.fromFilePath(paths);
    TextDetector textDetector = GoogleMlKit.vision.textDetector();
    RecognisedText recognisedText = await textDetector.processImage(inputImage);
    for(TextBlock block in recognisedText.blocks){
      for(TextLine line in block.lines){
        for(TextElement element in line.elements){
          setState(() {
           dataWrite = dataWrite + " " + element.text;
          });
        }
        dataWrite = dataWrite + '\n';
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: noImage ?
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width:  MediaQuery.of(context).size.width,
                color: Colors.indigoAccent,) :
              Container(
                height: MediaQuery.of(context).size.height ,
                width:  MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                image: DecorationImage(image: FileImage(
                  selectImage,
                ),
                  fit: BoxFit.cover
                ),
              ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: takeImage, child:
                Text(
                  'Select Image',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.indigoAccent[400]
                  ),
                ),
                style: ButtonStyle(
                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                     RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),),),
                  overlayColor: MaterialStateProperty.all(Color(0xff37474f)),
                  backgroundColor: MaterialStateProperty.all(Color(0x4dffffff))
                ),),
                SizedBox(width: 20.0,),
                ElevatedButton(onPressed: writeText, child:
                Text(
                  'Take Data',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.indigoAccent[400]
                  ),
                ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),),),
                      overlayColor: MaterialStateProperty.all(Color(0xff37474f)),
                      backgroundColor: MaterialStateProperty.all(Color(0x4dffffff))
                  ),),
               ],
            ),
            SizedBox(
            height: 20.0,
            ),
           Container(
             decoration: BoxDecoration(
               color: Colors.lightBlueAccent,
               border: Border.all(width: 10.0, color: Colors.white),
               borderRadius: BorderRadius.all(Radius.circular(10.0)),
             ),
               child:

           Text(dataWrite,
           style: TextStyle(
             color: Colors.white,
             fontSize: 20.0,
             fontWeight: FontWeight.bold,
           ),),),

          ],
        ),
      ),

      );
  }
}
