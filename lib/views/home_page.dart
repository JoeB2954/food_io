import 'package:flutter/material.dart';
import 'package:food_io/main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; 

class MealIOState extends State<MealIO> {
  
  // ignore: unused_field
  File ? _image;

  

  @override
  Widget build(BuildContext context){
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 3, 169, 244),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Icon(Icons.restaurant_menu),
            SizedBox(width: 10),
            Text('Meal.IO')
            ],
          ),
        ),
        
        body: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.only(bottom: 24),
          
          child: Stack(
            
             
            children: <Widget>[
              const Align(
                alignment:  Alignment(0.00,-0.40),
                child: 
                  Text('Take a photo of your receipt or choose a photo from your photo library', 
                  style: TextStyle( color: Color.fromARGB(255, 3, 169, 244), fontSize: 10 )),
                ),
              
              
              const Align(
                alignment:  Alignment.center,
                child: 
                  Icon(Icons.crop_free_rounded, color: Color.fromARGB(255, 3, 169, 244), size: 300),
                ),
              Container(
                margin: const EdgeInsets.all(24),
                
              
                
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                
                
                children: <Widget>[
              
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton (
                  style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(15),
                  ),
                onPressed: () {
                  _pickImageFromGallery();
                } ,
              
              
                child: const Icon(Icons.perm_media_rounded, color: Color.fromARGB(255, 3, 169, 244),)
                    ),
              ),
                        
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton (
                style: ElevatedButton.styleFrom(
                shape: const CircleBorder( ),
                padding: const EdgeInsets.all(15),
                ),
              onPressed: () {
                _pickImageFromCamera();
              } ,
              
              
              child: const Icon(Icons.camera_alt, color: Color.fromARGB(255, 3, 169, 244),)
                    ),
                  ),
                ],
              ),
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

  Future getImageTotext(final imagePath) async { 
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin); 
    final RecognizedText recognizedText = 
        await textRecognizer.processImage(InputImage.fromFilePath(imagePath)); 
    String text = recognizedText.text.toString(); 
    return text; 
  } 
}