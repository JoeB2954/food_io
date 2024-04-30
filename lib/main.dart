import 'package:flutter/material.dart';


void main() => runApp(const MealIO());

class MealIO extends StatelessWidget {
  const MealIO({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return MaterialApp(
    title: 'Meal.IO',
    theme: ThemeData(primarySwatch: Colors.blue,),
    home: const MealIO(),
    );
  }
}
