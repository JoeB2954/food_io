import 'package:food_io/models/recipe.dart';
import 'package:food_io/views/widgets/recipe_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class recipePage extends StatelessWidget {

  late final List<Recipe> _recipes;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu),
              SizedBox(width: 10),
              Text('Food Recipe')
            ],
          ),
        ),
        body: 
              ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  
                  return RecipeCard(
                      title: _recipes[index].name,
                      cookTime: _recipes[index].totalTime,
                      rating: _recipes[index].rating.toString(),
                      thumbnailUrl: _recipes[index].images);
                },
              )
              );
    
    
  }
}