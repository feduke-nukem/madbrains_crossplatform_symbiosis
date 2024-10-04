import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/api.g.dart',
    kotlinOut:
        'android/src/main/kotlin/com/example/coloringapi/coloring_api/api.g.kt',
    swiftOut: 'ios/Classes/api.g.swift',
    kotlinOptions: KotlinOptions(package: 'com.example.coloringsdk.api'),
  ),
)
@FlutterApi()
abstract interface class FlutterColoringApi {
  void onConfigurationProvided(ColoringSdkConfiguration configuration);
}

@HostApi()
abstract interface class ColoringHostApi {
  /// Json format.
  void onExitWithoutSubmit(String session);

  void onColoringSubmit(Uint8List image);
}

class ColoringSdkConfiguration {
  final Uint8List image;

  /// Hex format.
  final String initialColor;

  /// Json format.
  ///
  /// Only could be used from previously saved session [HostApi.onExitWithoutSubmit]
  ///
  /// or from [FlutterColoringApi.getSession].
  final String? session;

  /// Hex format.
  final List<String> colorPresets;

  final ColoringSdkLocalizations localizations;

  final ColoringSdkTheme theme;

  final ColoringSdkFeatureToggle featureToggle;

  ColoringSdkConfiguration({
    required this.colorPresets,
    required this.initialColor,
    required this.localizations,
    required this.image,
    required this.theme,
    required this.featureToggle,
    this.session,
  });
}

class ColoringSdkLocalizations {
  final String applicationTitle;
  final String submitTooltip;
  final String pickColorTooltip;
  final String colorPickerTitle;
  final String colorPickerPresetsTitle;
  final String screenTitle;

  ColoringSdkLocalizations({
    required this.applicationTitle,
    required this.submitTooltip,
    required this.pickColorTooltip,
    required this.colorPickerTitle,
    required this.colorPickerPresetsTitle,
    required this.screenTitle,
  });
}

class ColoringSdkTheme {
  /// Hex format.
  final String surface;

  /// Hex format.
  final String onSurface;

  /// Hex format.
  final String surfaceContainer;

  /// Hex format.
  final String secondary;

  final ColoringSdkButtonTheme buttonTheme;

  ColoringSdkTheme({
    required this.surface,
    required this.onSurface,
    required this.surfaceContainer,
    required this.secondary,
    required this.buttonTheme,
  });
}

class ColoringSdkButtonTheme {
  /// Hex format.
  final String background;

  /// Hex format.
  final String foreground;

  const ColoringSdkButtonTheme({
    required this.background,
    required this.foreground,
  });
}

class ColoringSdkFeatureToggle {
  final bool isColorPickerEnabled;
  final bool isScaleEnabled;
  final bool isPanEnabled;
  final List<ColoringSdkTool> enabledTools;
  final List<ColoringSdkAction> enabledActions;

  ColoringSdkFeatureToggle({
    required this.isColorPickerEnabled,
    required this.enabledTools,
    required this.isScaleEnabled,
    required this.isPanEnabled,
    required this.enabledActions,
  });
}

enum ColoringSdkTool {
  straightLine,
  rectangle,
  circle,
  eraser,
}

enum ColoringSdkAction {
  strokeWidth,
  undo,
  redo,
  rotate,
  clear,
}
