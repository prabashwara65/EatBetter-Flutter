import 'package:flutter/material.dart';
import 'package:eat_better/pages/common_tab.dart';

class FoodAnalysis extends StatefulWidget {
  const FoodAnalysis({super.key});

  @override
  State<FoodAnalysis> createState() => _FoodAnalysisState();
}

class _FoodAnalysisState extends State<FoodAnalysis> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Food Analysis'),
      //   backgroundColor: const Color.fromARGB(255, 150, 22, 0),
      // ),
      body: Container(
        // Apply gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(126, 248, 100, 37), // Orange
              Colors.white, // White
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Need to Analyze\nYour Food?',
                        style: TextStyle(
                            fontSize: w * .07,
                            fontWeight: FontWeight.bold,
                            height: 1),
                      ),
                      const Spacer()
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText:
                          'Type or Paste Ingredients\n\ncup rice,\n10 oz chickpeas,\n1/2 cup olive oil',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.all(20),
                      filled: true,
                      fillColor: const Color.fromARGB(99, 246, 106, 46),
                      focusColor: const Color.fromARGB(248, 246, 106, 46),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(248, 246, 106, 46),
                          width: 3,
                        ),
                      ),
                      helperText:
                          'Separate each ingredient with a comma', //optional
                      counterText: '0/500', //optional
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Add your action here
                    },
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll<Color>(
                        Color.fromARGB(211, 246, 106, 46),
                      ),
                      minimumSize: WidgetStatePropertyAll<Size>(
                        Size(w, 60), // Make it the same width as the TextField
                      ),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                      ),
                    ),
                    child: Text(
                      'Analyze',
                      style: TextStyle(
                          fontSize: w * .06,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Commons',
                          style: TextStyle(
                              fontSize: w * .07, fontWeight: FontWeight.bold)),
                      SizedBox(width: w*.022),
                    ],
                  ),
                  SizedBox(height: w*.022),
                  const CommonTab(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


//to add the gradient
//wrap below code in container. see food_analysis.dart for more details
// decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color.fromARGB(126, 248, 100, 37), // Orange
//               Colors.white, // White
//             ],
//           ),
//         ),