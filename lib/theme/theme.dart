import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4282474129),
      surfaceTint: Color(4282474129),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4292338687),
      onPrimaryContainer: Color(4278197054),
      secondary: Color(4278217069),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4288475381),
      onSecondaryContainer: Color(4278198305),
      tertiary: Color(4278217069),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4288475637),
      onTertiaryContainer: Color(4278198305),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294572543),
      onSurface: Color(4279835680),
      onSurfaceVariant: Color(4282664782),
      outline: Color(4285822847),
      outlineVariant: Color(4291086032),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281217078),
      inversePrimary: Color(4289382399),
      primaryFixed: Color(4292338687),
      onPrimaryFixed: Color(4278197054),
      primaryFixedDim: Color(4289382399),
      onPrimaryFixedVariant: Color(4280829815),
      secondaryFixed: Color(4288475381),
      onSecondaryFixed: Color(4278198305),
      secondaryFixedDim: Color(4286633177),
      onSecondaryFixedVariant: Color(4278210387),
      tertiaryFixed: Color(4288475637),
      onTertiaryFixed: Color(4278198305),
      tertiaryFixedDim: Color(4286633176),
      onTertiaryFixedVariant: Color(4278210386),
      surfaceDim: Color(4292467168),
      surfaceBright: Color(4294572543),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294177786),
      surfaceContainer: Color(4293783028),
      surfaceContainerHigh: Color(4293388526),
      surfaceContainerHighest: Color(4293059305),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4280501107),
      surfaceTint: Color(4282474129),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4283987368),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278209358),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4280516741),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278209358),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4280516741),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294572543),
      onSurface: Color(4279835680),
      onSurfaceVariant: Color(4282401610),
      outline: Color(4284243815),
      outlineVariant: Color(4286085763),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281217078),
      inversePrimary: Color(4289382399),
      primaryFixed: Color(4283987368),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4282342542),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4280516741),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4278216555),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4280516741),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278216555),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292467168),
      surfaceBright: Color(4294572543),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294177786),
      surfaceContainer: Color(4293783028),
      surfaceContainerHigh: Color(4293388526),
      surfaceContainerHighest: Color(4293059305),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278198603),
      surfaceTint: Color(4282474129),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280501107),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278200105),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4278209358),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278200105),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4278209358),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294572543),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280362027),
      outline: Color(4282401610),
      outlineVariant: Color(4282401610),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281217078),
      inversePrimary: Color(4293258495),
      primaryFixed: Color(4280501107),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278529115),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4278209358),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4278203189),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4278209358),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278203189),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292467168),
      surfaceBright: Color(4294572543),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294177786),
      surfaceContainer: Color(4293783028),
      surfaceContainerHigh: Color(4293388526),
      surfaceContainerHighest: Color(4293059305),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4289382399),
      surfaceTint: Color(4289382399),
      onPrimary: Color(4278923359),
      primaryContainer: Color(4280829815),
      onPrimaryContainer: Color(4292338687),
      secondary: Color(4286633177),
      onSecondary: Color(4278204217),
      secondaryContainer: Color(4278210387),
      onSecondaryContainer: Color(4288475381),
      tertiary: Color(4286633176),
      onTertiary: Color(4278204217),
      tertiaryContainer: Color(4278210386),
      onTertiaryContainer: Color(4288475637),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279309080),
      onSurface: Color(4293059305),
      onSurfaceVariant: Color(4291086032),
      outline: Color(4287533209),
      outlineVariant: Color(4282664782),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059305),
      inversePrimary: Color(4282474129),
      primaryFixed: Color(4292338687),
      onPrimaryFixed: Color(4278197054),
      primaryFixedDim: Color(4289382399),
      onPrimaryFixedVariant: Color(4280829815),
      secondaryFixed: Color(4288475381),
      onSecondaryFixed: Color(4278198305),
      secondaryFixedDim: Color(4286633177),
      onSecondaryFixedVariant: Color(4278210387),
      tertiaryFixed: Color(4288475637),
      onTertiaryFixed: Color(4278198305),
      tertiaryFixedDim: Color(4286633176),
      onTertiaryFixedVariant: Color(4278210386),
      surfaceDim: Color(4279309080),
      surfaceBright: Color(4281809214),
      surfaceContainerLowest: Color(4278980115),
      surfaceContainerLow: Color(4279835680),
      surfaceContainer: Color(4280164389),
      surfaceContainerHigh: Color(4280822319),
      surfaceContainerHighest: Color(4281546042),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4289842175),
      surfaceTint: Color(4289382399),
      onPrimary: Color(4278195765),
      primaryContainer: Color(4285829575),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4286896349),
      onSecondary: Color(4278196763),
      secondaryContainer: Color(4282883490),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4286896349),
      onTertiary: Color(4278196763),
      tertiaryContainer: Color(4282883490),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279309080),
      onSurface: Color(4294703871),
      onSurfaceVariant: Color(4291349204),
      outline: Color(4288717740),
      outlineVariant: Color(4286612364),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059305),
      inversePrimary: Color(4280895609),
      primaryFixed: Color(4292338687),
      onPrimaryFixed: Color(4278194475),
      primaryFixedDim: Color(4289382399),
      onPrimaryFixedVariant: Color(4279514725),
      secondaryFixed: Color(4288475381),
      onSecondaryFixed: Color(4278195221),
      secondaryFixedDim: Color(4286633177),
      onSecondaryFixedVariant: Color(4278205760),
      tertiaryFixed: Color(4288475637),
      onTertiaryFixed: Color(4278195221),
      tertiaryFixedDim: Color(4286633176),
      onTertiaryFixedVariant: Color(4278205759),
      surfaceDim: Color(4279309080),
      surfaceBright: Color(4281809214),
      surfaceContainerLowest: Color(4278980115),
      surfaceContainerLow: Color(4279835680),
      surfaceContainer: Color(4280164389),
      surfaceContainerHigh: Color(4280822319),
      surfaceContainerHighest: Color(4281546042),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294703871),
      surfaceTint: Color(4289382399),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4289842175),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4293721855),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4286896349),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4293656319),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4286896349),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279309080),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294703871),
      outline: Color(4291349204),
      outlineVariant: Color(4291349204),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059305),
      inversePrimary: Color(4278266201),
      primaryFixed: Color(4292732927),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4289842175),
      onPrimaryFixedVariant: Color(4278195765),
      secondaryFixed: Color(4288804346),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4286896349),
      onSecondaryFixedVariant: Color(4278196763),
      tertiaryFixed: Color(4288804345),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4286896349),
      onTertiaryFixedVariant: Color(4278196763),
      surfaceDim: Color(4279309080),
      surfaceBright: Color(4281809214),
      surfaceContainerLowest: Color(4278980115),
      surfaceContainerLow: Color(4279835680),
      surfaceContainer: Color(4280164389),
      surfaceContainerHigh: Color(4280822319),
      surfaceContainerHighest: Color(4281546042),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
