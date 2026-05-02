import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TemaWarna {
  static const Color latarGelap = Color(0xFF121212);
  static const Color kartuGelap = Color(0xFF1E1E1E);
  static const Color coklatTua = Color(0xFF3E2723);
  static const Color emasKopi = Color(0xFFC67C4E);
  static const Color orangeHangat = Color(0xFFED975A);
  static const Color abuAbu = Color(0xFF9E9E9E);
  static const Color putih = Color(0xFFFFFFFF);
  static const Color hitam = Color(0xFF000000);
  static const Color cream = Color(0xFFF5F5DC);
  static const Color orangeKopi = Color(0xFFC67C4E);
  static const Color transparan = Colors.transparent;
}

class TemaTeks {
  static TextStyle poppins(double size, FontWeight weight, Color color) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }

  static TextStyle montserrat(double size, FontWeight weight, Color color) {
    return GoogleFonts.montserrat(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }
}
