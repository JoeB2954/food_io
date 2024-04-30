import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:io';
import 'package:food_io/views/home_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/vision/v1.dart';

void main() => runApp(MealIO());

class MealIO extends StatefulWidget{

  
  @override
  State<StatefulWidget> createState(){
  
    return MealIOState();
  }
}



