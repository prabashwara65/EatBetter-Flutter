import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const CircleButton({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Column(
      children: [
        CircleAvatar(
          radius: w * 0.086,
          backgroundColor: Colors.redAccent,
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
              size: w * 0.06, // Adjust the icon size to match button size
            ),
          ),
        ),
        SizedBox(
          height: h * .01, // Increased space between button and label
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: w * 0.045, // Larger font size for better readability
            fontWeight: FontWeight.w600, // Bold text for better visibility
            color: Colors.black, // Darker color for contrast
          ),
        ),
      ],
    );
  }
}
