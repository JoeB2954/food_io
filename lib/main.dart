import 'package:flutter/material.dart';
import 'package:food_io/views/home_page.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; 

void main() => runApp(const MealIO());

class MealIO extends StatelessWidget {
  const MealIO({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
      //home: MyHomePage(),

      routes: {
        '/':(context) => MyHomePage(),
        '/recipes':(context) => MyRecipeFinder(),
        //'/recipeinfo':(context) => MyRecipeInfo()
      },
    );
  }
  
}



