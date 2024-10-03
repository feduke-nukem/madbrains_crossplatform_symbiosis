import 'package:coloring_sdk/localization/coloring_sdk_localizations_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'
    as flutter_color_picker;

class ColorPicker extends StatefulWidget {
  final ValueChanged<Color>? onSubmit;
  final VoidCallback? onCancel;
  final Color initialColor;
  final Iterable<Color> presets;

  const ColorPicker({
    super.key,
    required this.initialColor,
    this.onSubmit,
    this.onCancel,
    this.presets = const [],
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late var _currentColor = widget.initialColor;

  @override
  Widget build(BuildContext context) {
    final localizations = ColoringSdkLocalizationsDelegate.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: IconButton(
              onPressed: () => widget.onCancel?.call(),
              icon: const Icon(Icons.close),
            ),
            title: Center(child: Text(localizations.colorPickerTitle)),
            trailing: IconButton(
              onPressed: () => widget.onSubmit?.call(_currentColor),
              icon: const Icon(Icons.check),
            ),
          ),
          const SizedBox(height: 20),
          flutter_color_picker.ColorPicker(
            pickerColor: _currentColor,
            onColorChanged: (color) => _currentColor = color,
          ),
          if (widget.presets.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  localizations.colorPickerPresetsTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                height: 100,
                width: constraints.maxWidth,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemCount: widget.presets.length,
                  itemBuilder: (_, index) {
                    final color = widget.presets.elementAt(index);

                    return GestureDetector(
                      onTap: () => setState(() => _currentColor = color),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: const SizedBox.square(dimension: 50),
                      ),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}
