import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MealIO extends StatefulWidget{
  const MealIO({Key? key}) : super(key : key);

  
  @override
  State<StatefulWidget> createState(){
  
    return MealIOState();
  }
}

class MealIOState extends State<MealIO> {
  
  File ? _image;

  

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text ('Meal.IO'),
        ),
        body: Center(
           child: Column(
            children: <Widget>[
              IconButton( icon: const Icon(Icons.insert_drive_file),
              onPressed: () {
                _pickImageFromGallery();
              },
              ),
              const SizedBox(height: 10.0,),
              IconButton( icon: const Icon(Icons.camera_alt),
              onPressed: () {
                _pickImageFromCamera();
              },
              ),
              
            ],
           ),
          ),
        ),
    );
  }
  Future _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _image = File(returnedImage.path);
    });
  }
  Future _pickImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      _image = File(returnedImage.path);
    });
  }
}