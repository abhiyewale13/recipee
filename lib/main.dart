import 'package:flutter/material.dart';

import 'Views/home_screen_recipe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Food Recipe",
      home: HomeScreenRecipe(),
    );
  }
}
