import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text bigText(String x) {
  return Text(x,
      style: GoogleFonts.abel(
        letterSpacing: 3,
        fontSize: 40,
        color: Colors.deepOrangeAccent,
        fontWeight: FontWeight.bold,
      ));
}

Text midText(String x) {
  return Text(x,
      style: GoogleFonts.abel(
        letterSpacing: 3,
        fontSize: 30,
        color: Colors.deepOrangeAccent,
        fontWeight: FontWeight.bold,
      ));
}

Text smallText(String x) {
  return Text(x,
      style: GoogleFonts.abel(
        letterSpacing: 3,
        fontSize: 20,
        color: Colors.deepOrangeAccent,
        fontWeight: FontWeight.bold,
      ));
}

Text blackBigText(String x) {
  return Text(x,
      style: GoogleFonts.abel(
        letterSpacing: 3,
        fontSize: 30,
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ));
}

Text blackMidText(String x) {
  return Text(x,
      style: GoogleFonts.aBeeZee(
        letterSpacing: 3,
        fontSize: 20,
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ));
}

Text blackSmallText(String x) {
  return Text(x,
      style: GoogleFonts.aBeeZee(
        letterSpacing: 2,
        fontSize: 25,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ));
}
