import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class NutriDetails extends StatelessWidget {
  final int id;
  final String imageUrl;

  const NutriDetails({super.key, required this.id, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutritional Details'),
        backgroundColor: Color.fromARGB(126, 248, 100, 37),
        leading: IconButton(
          iconSize: 30,
          icon: Image.asset('assets/icons/BackButton.png'),
          onPressed: () {
            Navigator.pop(
                context); // This will navigate back to the previous screen
          },
        ),
      ),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display image in a centered circle
              CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(imageUrl),
              ),
              const SizedBox(height: 20),
              Text(
                'Nutritional Details for ID: $id',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: h * .3,
                width: w,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(101, 248, 100, 37),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _RadialProgress(
                          width: w * .39,
                          height: h * .19,
                          progress: 0.7,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _IngredientProgress(
                              ingredient: "Protein",
                              progress: 0.3,
                              progressColor: Colors.green,
                              leftAmount: 72,
                              width: w * 0.39,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _IngredientProgress(
                              ingredient: "Carbs",
                              progress: 0.2,
                              progressColor: Colors.red,
                              leftAmount: 252,
                              width: w * 0.39,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _IngredientProgress(
                              ingredient: "Fat",
                              progress: 0.1,
                              progressColor: Colors.yellow,
                              leftAmount: 61,
                              width: w * 0.39,
                            ),
                          ],
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IngredientProgress extends StatelessWidget {
  final String ingredient;
  final int leftAmount;
  final double progress, width;
  final Color progressColor;

  const _IngredientProgress(
      {super.key,
      required this.ingredient,
      required this.leftAmount,
      required this.progress,
      required this.width,
      required this.progressColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ingredient.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 15,
                  width: width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black12,
                  ),
                ),
                Container(
                  height: 15,
                  width: width * progress,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: progressColor,
                  ),
                )
              ],
            ),
            Text("${leftAmount}g left"),
          ],
        ),
      ],
    );
  }
}

class _NutrientInfo extends StatelessWidget {
  final String nutrient, value;
  const _NutrientInfo({super.key, required this.nutrient, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          nutrient,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [
                  Color.fromARGB(192, 187, 5, 5), // Start color
                  Color.fromARGB(255, 255, 102, 0), // End color
                ],
              ).createShader(Rect.fromLTWH(0, 0, 100, 50)),
          ),
        ),
      ],
    );
  }
}

class _RadialProgress extends StatelessWidget {
  final double width, height, progress;
  const _RadialProgress(
      {super.key,
      required this.width,
      required this.height,
      required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(
        progress: progress,
      ),
      child: Container(
        height: height,
        width: width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "1731",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [
                          Color.fromARGB(192, 187, 5, 5), // Start color
                          Color.fromARGB(255, 255, 102, 0), // End color
                        ],
                      ).createShader(Rect.fromLTWH(0, 0, 100, 50)),
                  ),
                ),
                const TextSpan(text: "\n"),
                TextSpan(
                  text: "KCal",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [
                          Color.fromARGB(192, 187, 5, 5), // Start color
                          Color.fromARGB(255, 255, 102, 0), // End color
                        ],
                      ).createShader(Rect.fromLTWH(0, 0, 100, 50)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double progress;

  const _RadialPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..shader = const LinearGradient(
        colors: [
          Color.fromARGB(192, 187, 5, 5), // Start color
          Color.fromARGB(255, 255, 102, 0), // End color
        ],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(-relativeProgress),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
