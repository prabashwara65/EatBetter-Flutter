import 'package:flutter/material.dart';

class IngredientItem extends StatelessWidget {
  final String quantity, measure, name;
  const IngredientItem(
      {super.key,
      required this.quantity,
      required this.measure,
      required this.name});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: h * 0.01,
          horizontal: w * 0.05), // Adjusted horizontal margin
      padding: EdgeInsets.all(w * 0.03), // Consistent padding
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(.2),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Wrapping the text inside an Expanded widget to avoid overflow
          Expanded(
            child: Text(
              "$quantity $measure of $name",
              style: TextStyle(
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              overflow: TextOverflow.visible, // Allow text wrapping
              softWrap: true,
            ),
          ),
          SizedBox(width: w * 0.02), // Spacing between text and icon
          const Icon(
            Icons.add,
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
