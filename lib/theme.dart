import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// use brandTheme to set a custom overall theme for all your apps to use
ThemeData brandTheme({
  bool darkMode = false,
  bool? useDarkBackground,
  Color? backgroundColor,
  Color? textColor,
  Color darkBackgroundColor = const Color.fromARGB(255, 17, 17, 17),
  Color seedColor = Colors.red,
  TextTheme? customFont,
  double iconSize = 30,
}) {
  bool onApple = defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;
  TextTheme textTheme = customFont ?? GoogleFonts.poppinsTextTheme();
  bool darkBackground = useDarkBackground ?? onApple;
  Color? background = backgroundColor ?? (darkBackground ? darkBackgroundColor : null);
  Color text = textColor ?? (darkMode ? Colors.white : Colors.black);

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: darkMode ? Brightness.dark : Brightness.light,
    ),
    textTheme: textTheme.apply(
      bodyColor: text,
      displayColor: text,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(backgroundColor: background),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: background),
    iconTheme: IconThemeData(size: iconSize),
    useMaterial3: true,
  );
}

@Deprecated("Use 'brandTheme' instead.")
ThemeData customTheme({
  bool darkMode = false,
  Color seedColor = Colors.red,
  TextTheme? textStyle,
  double iconSize = 30,
}) {
  return brandTheme(
    darkMode: darkMode,
    seedColor: seedColor,
    customFont: textStyle,
    iconSize: iconSize
  );
}

class GradientColor {
  final Color color;
  final int intensity;

  GradientColor(this.color, {this.intensity = 1}) {
    assert(intensity >= 0, "Color intensity must be non-negative.");
  }
}

List<Color> buildGradientColors(List<GradientColor> colors) {
  List<Color> output = [];
  for (GradientColor item in colors) {
    for (int i = 0; i < item.intensity; i++) {
      output.add(item.color);
    }
  }
  return output;
}

extension on Text {
  // ignore: unused_element
  Widget gradient({required List<GradientColor> colors}) {
    if (data == null) {
      throw Exception("Text data cannot be null.");
    }

    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: buildGradientColors(colors),
      ).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),

      child: Text(
        data!,
        style: (style ?? TextStyle()).copyWith(color: Colors.white),
        key: key,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      ),
    );
  }
}
