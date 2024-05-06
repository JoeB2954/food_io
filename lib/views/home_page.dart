import 'package:flutter/material.dart';
import 'package:food_io/main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; 
import 'dart:convert';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'package:googleapis/language/v1.dart';


class MealIOState extends State<MealIO> {
  
  // ignore: unused_field
  File ? _image;
  late String _text = "";
  

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
                  _pickImageFromGallery()  ;
                  
                 
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
                 _pickImageFromCamera() ;
                
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
    getImageTotext(returnedImage.path);
  }
  Future _pickImageFromCamera() async {
    
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    getImageTotext(returnedImage.path);
  }
  Future getImageTotext(final imagePath) async { 
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin); 
    final RecognizedText recognizedText = 
        await textRecognizer.processImage(InputImage.fromFilePath(imagePath)); 
    String text = ""; 
    for (TextBlock block in recognizedText.blocks) {
    text += block.text + " "; // Add a space between blocks
  }
    text = text.trim();
    extractFoodItems(text);
  } 

  Future<List<String>> extractFoodItems(String text) async {
  const apiKey = 'AIzaSyAqkEsNuGGXRliOKh5PKOUzMkVKp2AmXi4'; // Replace with your Google Cloud API key
  const apiUrl =
      'https://language.googleapis.com/v1/documents:analyzeEntities?key=$apiKey';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'document': {
        'type': 'PLAIN_TEXT',
        'content': text,
      },
      'encodingType': 'UTF8',
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    final List<String> foodItems = [];

    for (final entity in responseData['entities']) {
      if (entity['type'] == 'CONSUMER_GOOD') {
        foodItems.add(entity['name']);
      }
    }
    print(foodItems);
    return foodItems;
  } else {
    throw Exception('Failed to analyze text: ${response.reasonPhrase}');
  }
}
}