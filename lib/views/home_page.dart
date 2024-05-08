import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_io/consts.dart';
import 'package:food_io/main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; 
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart'; // Imported chat gpt

import 'model/recipe.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

List<String> final_ingredients = [];


class MyHomePage extends StatelessWidget {
  
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
                onPressed: () async {
                  await _pickImageFromGallery();
                  //Navigator.push(context,MaterialPageRoute(builder: (context) => MyRecipeFinder()));
                  Navigator.pushNamed(context, '/recipes');
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
    await getImageTotext(returnedImage.path);
  }
  Future _pickImageFromCamera() async {
    
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    await getImageTotext(returnedImage.path);
  }
  Future getImageTotext(final imagePath) async { 
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin); 
    final RecognizedText recognizedText = 
        await textRecognizer.processImage(InputImage.fromFilePath(imagePath)); 

    
    String text = recognizedText.text.toString(); 
    
    await imageToTextGpt(text);
  
  } 


  Future<void> imageToTextGpt(String text) async {
    
    //instance setup for chat gpt api
    final _openAI = OpenAI.instance.build(token: OPENAI_API_KEY, 
    baseOption: HttpSetup(
      receiveTimeout: const Duration(
        seconds: 5,),
        ),
        enableLog: true,
        );

    //request for chatgpt
    final request = CompleteText(
        prompt:"Identify the ingredients of this shopping receipt text, then autocorrect the misspelled/incomplete ingredients and only output the ingredients as a simple list with commas between them. Respond with only the list. \"$text\"",
        maxTokens: 200,
        model: Gpt3TurboInstruct());

    //gets response from api
    CompleteResponse? response = await _openAI.onCompletion(request: request);
    debugPrint("$response");
    
    
    String gpt_output = "";
    for(var element in response!.choices)
    {
      gpt_output = gpt_output + element.text;
    }

    //ouputs ingredients list as a String
    print ("gptout = "+ gpt_output);

    //ouputs ingredients list as a list 
    List<String> Ingredients = Finished_Ingredients_List(gpt_output);
    //print("final output = " + Ingredients.toString());
    final_ingredients = Ingredients;
    
    
    //Navigator.pushNamed('/recipes');
    //Navigator.push(context,MaterialPageRoute(builder: (context) => MyRecipeFinder()));
    //NavigationState
  
}

List<String> Finished_Ingredients_List(String txt)
{
  //adding ingredients to list
  String ingredient = "";
  List<String> ingredient_list = [];

  for (int i = 0; i < txt.length ; i++) {
  
    //if there is a comma put an ingredient in the list
    if(txt[i] == ',')
    { 
      ingredient_list.add(ingredient);
      ingredient = "";
    }
    else
    {
      //adds current letter to the current ingredient
      ingredient += txt[i];
    }
    
    //adds last letter of the word to the ingredient
    if(i == txt.length - 1)
    {
      ingredient_list.add(ingredient);
      ingredient = "";
    }
   
  }

  return ingredient_list;
}
}




//page 2
class MyRecipeFinder extends StatelessWidget {
  MyRecipeFinder({super.key});

  List<Recipe> recipes = [];

  Future getRecipes() async {
  print("page 2 = " + final_ingredients.toString());
  String Api_ingredients = "";
  
  for(int i = 0;i < final_ingredients.length; i++)
  {
    print("food = "+final_ingredients[i]);
    if(i == 0)
    {
      Api_ingredients += final_ingredients[i];
    }
    else{
      Api_ingredients += "," + "+"+final_ingredients[i] ;
    }
    

  }
  
  print("api url ingredient shit = "+Api_ingredients);
  String url = "https://api.spoonacular.com/recipes/findByIngredients?apiKey=$SPOONACULAR_API_KEY&ingredients=$Api_ingredients&number=3";
  final uri = Uri.parse(url);
  var response = await http.get(uri);

  final jsonData = jsonDecode(response.body);

  for(var eachRecipe in jsonData)
  {
    final recipe = Recipe(
    title: eachRecipe['title'], 
    image: eachRecipe['image'], 
    missedIngredientCount: eachRecipe['missedIngredientCount'],
    id:eachRecipe['id']);

    recipes.add(recipe);
  }

  print(recipes.length);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Recipes'),
        
        ),

        body: FutureBuilder(future: getRecipes(),
        builder: (context,snapshot){
          // is it done loading
          if(snapshot.connectionState == ConnectionState.done){
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index){
                return Padding(padding: const EdgeInsets.all(8),
                  
                  
                  child: Container(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  height: 400,
                  width: 500,
                  child: Column(
                  children: [
                  FadeInImage.assetNetwork(placeholder: 'images/my_loading.gif', image: recipes[index].image,alignment: Alignment.topCenter,),

                  Text(recipes[index].title),
                  Text("missing ingredients = "+recipes[index].missedIngredientCount.toString())
                  ],
                )));
              });
          }
          // if it's still loading, show loading circle
          else{
            return Center(child: CircularProgressIndicator(),
            );
          }
        }),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            print('Pressed button!!!');
            getRecipes();
        },
        )
      ),
    );
  }
}