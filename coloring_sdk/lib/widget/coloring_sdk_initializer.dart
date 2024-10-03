import 'package:coloring_api/coloring_api.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ColoringSdkInitializer extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    ColoringSdkConfiguration configuration,
    ui.Image image,
  ) builder;

  const ColoringSdkInitializer({
    required this.builder,
    super.key,
  });

  @override
  State<ColoringSdkInitializer> createState() => _ColoringSdkInitializerState();
}

class _ColoringSdkInitializerState extends State<ColoringSdkInitializer> {
  ColoringSdkConfiguration? _configuration;
  ui.Image? _inputImage;

  @override
  void initState() {
    super.initState();

    FlutterColoringApi.setUp(
      _FlutterColoringApiHandler(
        onConfigurationProvidedCallback: (configuration) async {
          final imageBytes = configuration.image;
          final image = await decodeImageFromList(imageBytes);

          if (!mounted) return;

          setState(() {
            _configuration = configuration;
            _inputImage = image;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _configuration == null
        ? const SizedBox.shrink()
        : widget.builder(context, _configuration!, _inputImage!);
  }
}

class _FlutterColoringApiHandler extends FlutterColoringApi {
  final void Function(ColoringSdkConfiguration configuration)
      onConfigurationProvidedCallback;

  _FlutterColoringApiHandler({
    required this.onConfigurationProvidedCallback,
  });

  @override
  void onConfigurationProvided(ColoringSdkConfiguration configuration) =>
      onConfigurationProvidedCallback(configuration);
}
