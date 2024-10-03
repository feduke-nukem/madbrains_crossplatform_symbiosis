import 'package:coloring_api/coloring_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ColoringSdkLocalizationsDelegate
    extends LocalizationsDelegate<ColoringSdkLocalizations> {
  final ColoringSdkLocalizations localizations;
  const ColoringSdkLocalizationsDelegate(this.localizations);

  static ColoringSdkLocalizations of(BuildContext context) {
    return Localizations.of<ColoringSdkLocalizations>(
      context,
      ColoringSdkLocalizations,
    )!;
  }

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<ColoringSdkLocalizations> load(Locale locale) =>
      SynchronousFuture<ColoringSdkLocalizations>(localizations);

  @override
  bool shouldReload(ColoringSdkLocalizationsDelegate old) {
    final oldLocalizations = old.localizations;

    return localizations.applicationTitle !=
            oldLocalizations.applicationTitle ||
        localizations.submitTooltip != oldLocalizations.submitTooltip ||
        localizations.pickColorTooltip != oldLocalizations.pickColorTooltip ||
        localizations.colorPickerTitle != oldLocalizations.colorPickerTitle ||
        localizations.colorPickerPresetsTitle !=
            oldLocalizations.colorPickerPresetsTitle ||
        localizations.screenTitle != oldLocalizations.screenTitle;
  }
}
