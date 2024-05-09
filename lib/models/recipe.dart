import 'dart:convert';
import 'package:http/http.dart' as http;

class Recipe{

  final String name;
  final String images;
  final double rating;
  final String totalTime;

  Recipe(
    {required this.name, 
    required this.images, 
    required this.rating, 
    required this.totalTime
  });


  factory Recipe.fromJson(dynamic json){
    return Recipe(
      name: json['name'] as String,
      images: json ['images'][0]['hostedLargeUrl'] as String, 
      rating: json['rating'] as double,
      totalTime: json['totalTime'] as String
    );
  }

  static List <Recipe> recipesFromSnapshot(List snapshot){
    return snapshot.map(
      (data){
        return Recipe.fromJson(data);
      }

    ).toList();
  }
}

class YummlyAPI {
  
  static Future<List<Recipe>> searchRecipes(List<String> ingredients) async {
    //List to store recipes from all searches
    List<Recipe> allRecipes = [];

    //Iterate over each ingredient
    for (String ingredient in ingredients) {
      //Encode the ingredient for the query parameter
      String encodedIngredient = Uri.encodeComponent(ingredient);
      
      //Construct the URI for the search with the current ingredient
      var uri = Uri.https('yummly2.p.rapidapi.com', '/feeds/search', {
        "maxResult": "18",
        "start": "0",
        "q": encodedIngredient //Set the current ingredient as the query
      });

      final response = await http.get(uri, headers: {
        "X-RapidAPI-Key": "45fa38084fmsh9cbdc0fabf2fd87p1cdd0djsned68457a742c",
        'X-RapidAPI-Host': 'yummly2.p.rapidapi.com',
        "useQueryString": "true"
      });

      if (response.statusCode == 200) {
        //Parse the response JSON
        List<dynamic> data = json.decode(response.body)["feed"];
        //Convert the data into a list of Recipe objects
        List<Recipe> recipes = Recipe.recipesFromSnapshot(data);
        //Add the recipes to the list of all recipes
        allRecipes.addAll(recipes);
      } else {
        //Handle errors if needed
        print('Error: ${response.statusCode}');
      }
    }

    // Return the combined list of recipes
    return allRecipes;
  }

}