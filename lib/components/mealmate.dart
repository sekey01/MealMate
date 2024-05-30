import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MealMate extends StatelessWidget {
  const MealMate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.white,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          RichText(
            text: const TextSpan(
              text: 'Meal',
              style: TextStyle(
                letterSpacing: 3,
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          RichText(
            text: TextSpan(
                text: 'Mate🍕',
                style: GoogleFonts.abel(
                  letterSpacing: 3,
                  fontSize: 25,
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.bold,
                )),
          )
        ]),
      ),
    );
  }
}
