import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color emerald = Color(0xFF0B3D2E);
  static const Color deepEmerald = Color(0xFF06261D);
  static const Color surfaceGreen = Color(0xFF103F31);
  static const Color softGreen = Color(0xFFEAF4EF);
  static const Color quranGold = Color(0xFFD6B25E);
  static const Color brightGold = Color(0xFFF2D27A);

  static TextStyle get quranTextStyle => GoogleFonts.amiriQuran(
        color: brightGold,
        fontSize: 26,
        height: 2.1,
        fontWeight: FontWeight.w500,
      );

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.cairoTextTheme(base.textTheme).apply(
      bodyColor: quranGold,
      displayColor: quranGold,
    );

    return base.copyWith(
      scaffoldBackgroundColor: emerald,
      colorScheme: ColorScheme.fromSeed(
        seedColor: emerald,
        brightness: Brightness.light,
        primary: quranGold,
        onPrimary: deepEmerald,
        secondary: brightGold,
        onSecondary: deepEmerald,
        surface: surfaceGreen,
        onSurface: quranGold,
        error: const Color(0xFFFFB4AB),
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: deepEmerald,
        foregroundColor: quranGold,
        titleTextStyle: GoogleFonts.cairo(
          color: quranGold,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: const IconThemeData(color: quranGold),
      ),
      iconTheme: const IconThemeData(color: quranGold),
      dividerTheme: const DividerThemeData(color: quranGold, thickness: 0.5),
      cardTheme: CardThemeData(
        color: surfaceGreen,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: quranGold, width: 0.8),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: quranGold,
        textColor: quranGold,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: quranGold,
          foregroundColor: deepEmerald,
          textStyle: GoogleFonts.cairo(fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceGreen,
        modalBackgroundColor: surfaceGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: quranGold),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: deepEmerald,
        contentTextStyle: GoogleFonts.cairo(color: quranGold),
      ),
    );
  }

  static ThemeData get darkTheme => lightTheme;
}
