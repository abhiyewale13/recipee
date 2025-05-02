import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

import '../models/ingredients.dart';
import '../models/recipe_model.dart';

class ItemsDetailsScreens extends StatefulWidget {
  final RecipeItems recipeItems;
  const ItemsDetailsScreens({super.key, required this.recipeItems});

  @override
  State<ItemsDetailsScreens> createState() => _ItemsDetailsScreensState();
}

class _ItemsDetailsScreensState extends State<ItemsDetailsScreens> {
  final String _apiKey = 'AIzaSyD94uO3lrImmUx1PQUNwrNsn4oDBOXyB4I';
  late GenerativeModel model;
  GenerateContentResponse? finalresponse;
  bool isLoading = false;
  bool isSearch = false;

  @override
  void initState() {
    super.initState();
    model = GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: _apiKey);
    generateResponse();
  }

  Future<void> generateResponse() async {
    var question = widget.recipeItems..name;

    setState(() {
      isSearch = true;
      isLoading = true;
    });

    try {
      final content = [
        Content.text("Please give me recipe step by step of ${question.name}"),
      ];
      final response = await model.generateContent(content);
      setState(() {
        finalresponse = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong: $e")));
    } finally {
      setState(() {
        isLoading = false;
      });
      log("response recived");
      log(finalresponse!.text!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.5,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),

                      image: DecorationImage(
                        image: AssetImage(widget.recipeItems.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.black38,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(widget.recipeItems.woner),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recipeItems.wonerName,
                          maxLines: 1,
                          style: const TextStyle(
                            height: 0,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "12 Recipes Shared",
                          style: TextStyle(
                            height: 0,
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${widget.recipeItems.rate}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 5),
                          RatingBar.builder(
                            itemSize: 15,
                            initialRating: widget.recipeItems.rate,
                            unratedColor: Colors.grey.shade400,
                            itemBuilder: (context, index) {
                              return const Icon(
                                Icons.star,
                                color: Colors.amberAccent,
                              );
                            },
                            onRatingUpdate: (value) {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${widget.recipeItems.reviews} Reviews",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        widget.recipeItems.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "1 Bowl (${widget.recipeItems.weight}g)",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    "See details",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyProgressIndicatorValue(
                    name: "Carbs",
                    amount: "${widget.recipeItems.carb} g",
                    percentage: "(56%)",
                    color: Colors.green,
                    data: 0.4,
                  ),
                  MyProgressIndicatorValue(
                    color: Colors.red,
                    name: 'Fat',
                    amount: '${widget.recipeItems.fat} g',
                    percentage: '(72%)',
                    data: 0.6,
                  ),
                  MyProgressIndicatorValue(
                    color: Colors.orange,
                    name: 'Protein',
                    amount: '${widget.recipeItems.protein} g',
                    percentage: '(8%)',
                    data: 0.2,
                  ),
                  MyProgressIndicatorValue(
                    color: Colors.green,
                    name: 'Calories',
                    amount: '${widget.recipeItems.calorie} kkal',
                    percentage: "",
                    data: 0.7,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ingredients",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "See all",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  ingredients.length,
                  (index) => Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: ingredients[index].color,
                        child: Image.asset(
                          ingredients[index].image,
                          height: 40,
                          width: 40,
                        ),
                      ),

                      Text(
                        ingredients[index].name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, bottom: 5),
              child: Row(
                children: [
                  Text(
                    "Recipe ...!",
                    style: GoogleFonts.inter(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 64, 201, 135),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, bottom: 30),
              child: SizedBox(
                child:
                    finalresponse == null
                        ? CircularProgressIndicator(color: Colors.green)
                        : Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: MarkdownBody(
                            data: finalresponse!.text!,
                            styleSheet: MarkdownStyleSheet(
                              listIndent: 8,
                            
                              listBullet:TextStyle(color: Colors.green[600], fontSize: 15) ,
                              
                              
                              a: TextStyle(color: Colors.green[500], fontSize: 14),
                              p: TextStyle(color: Colors.green, fontSize: 15),
                              h1: TextStyle(color: Colors.green, fontSize: 20),
                            h2:   TextStyle(color: Colors.green, fontSize: 18),
                            h3: TextStyle(color: Colors.green, fontSize: 15),
                            strong: TextStyle(color: Colors.green[700], fontSize: 25,
                            
                            ),
                            ),
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyProgressIndicatorValue extends StatelessWidget {
  final String? name, amount;
  final String percentage;
  final Color color;
  final double data;
  const MyProgressIndicatorValue({
    super.key,
    required this.name,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 20,
      circularStrokeCap: CircularStrokeCap.round,
      percent: data,
      lineWidth: 7,
      reverse: true,
      backgroundColor: color.withOpacity(0.2),
      animation: true,
      animationDuration: 500,
      restartAnimation: true,
      progressColor: color,
      header: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(
          name!,
          style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 12),
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$amount ',
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
              TextSpan(
                text: percentage,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(0, size.height, 0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
