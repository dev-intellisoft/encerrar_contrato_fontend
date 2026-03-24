import 'package:flutter/material.dart';

class AppTheme {
  // =========================
  // PALETA ENCERRAR
  // =========================
  static const Color primario = Color(0xFF5E17EB);
  static const Color secundario = Color(0xFF2576FB);
  static const Color claro = Color(0xFF36BAFE);

  static const Color bg = Color(0xFF070710);
  static const Color bg2 = Color(0xFF0B0B12);

  static const Color ink = Color(0xFFFFFFFF);

  static ScrollbarThemeData get _scrollbarTheme => ScrollbarThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.dragged)) {
        return secundario.withOpacity(.96);
      }
      if (states.contains(WidgetState.hovered)) {
        return claro.withOpacity(.94);
      }
      return primario.withOpacity(.82);
    }),
    trackColor: WidgetStatePropertyAll(Colors.white.withOpacity(.08)),
    trackBorderColor: WidgetStatePropertyAll(Colors.white.withOpacity(.10)),
    radius: const Radius.circular(999),
    thickness: const WidgetStatePropertyAll(10),
    crossAxisMargin: 4,
    mainAxisMargin: 4,
    minThumbLength: 56,
  );

  // =========================
  // DARK THEME (PRINCIPAL)
  // =========================
  static ThemeData get dark {
    final muted = Colors.white.withOpacity(.72);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Base
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primario,
        brightness: Brightness.dark,
        primary: primario,
        secondary: secundario,
        surface: bg2,
        onSurface: ink,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: bg2,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white.withOpacity(.92),
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(.92)),
        titleTextStyle: const TextStyle(
          color: ink,
          fontWeight: FontWeight.w900,
          fontSize: 16,
        ),
      ),

      // Text
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: Colors.white.withOpacity(.88),
          fontWeight: FontWeight.w700,
        ),
        bodySmall: TextStyle(
          color: Colors.white.withOpacity(.70),
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: const TextStyle(
          color: ink,
          fontWeight: FontWeight.w900,
        ),
        titleMedium: const TextStyle(
          color: ink,
          fontWeight: FontWeight.w900,
        ),
        labelLarge: const TextStyle(
          color: ink,
          fontWeight: FontWeight.w900,
        ),
      ),

      // Inputs globales
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(.06),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        labelStyle: TextStyle(
          color: muted,
          fontWeight: FontWeight.w700,
        ),
        floatingLabelStyle: TextStyle(
          color: claro.withOpacity(.95),
          fontWeight: FontWeight.w800,
        ),
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(.55),
          fontWeight: FontWeight.w600,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primario.withOpacity(.75), width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.redAccent.withOpacity(.85)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.redAccent.withOpacity(.95)),
        ),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primario,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: .2,
          ),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: primario.withOpacity(.55), width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: .2,
          ),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white.withOpacity(.82),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primario,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // Dialogs (✅ correcto Material 3)
      dialogTheme: DialogThemeData(
        backgroundColor: bg2,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        titleTextStyle: const TextStyle(
          color: ink,
          fontWeight: FontWeight.w900,
          fontSize: 14,
        ),
        contentTextStyle: TextStyle(
          color: Colors.white.withOpacity(.78),
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
      ),

      // Dividers
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(.08),
        thickness: 1,
      ),

      scrollbarTheme: _scrollbarTheme,

      // ListTiles
      listTileTheme: ListTileThemeData(
        iconColor: Colors.white.withOpacity(.88),
        textColor: Colors.white.withOpacity(.88),
      ),
    );
  }

  // =========================
  // LIGHT (OPCIONAL)
  // =========================
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primario,
        brightness: Brightness.light,
        primary: primario,
        secondary: secundario,
      ),
      scaffoldBackgroundColor: Colors.white,
      scrollbarTheme: _scrollbarTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
    );
  }
}
