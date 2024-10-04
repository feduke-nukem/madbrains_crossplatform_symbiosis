import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:coloring_api/coloring_api.dart';
import 'package:coloring_sdk/localization/coloring_sdk_localizations_delegate.dart';
import 'package:coloring_sdk/util/paint_content_x.dart';
import 'package:coloring_sdk/util/string_x.dart';
import 'package:coloring_sdk/widget/aspect_listenable_builder.dart';
import 'package:coloring_sdk/widget/color_picker.dart';
import 'package:coloring_sdk/widget/coloring_sdk_initializer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main(List<String> args) => colorImage(args);

@pragma('vm:entry-point')
Future<void> colorImage(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final hostApi = ColoringHostApi();

  runApp(
    ColoringSdkInitializer(
      builder: (_, configuration, image) {
        return ColoringApp(
          key: ObjectKey(configuration),
          configuration: configuration,
          child: ColoringScreen(
            hostApi: hostApi,
            configuration: configuration,
            image: image,
          ),
        );
      },
    ),
  );
}

class ColoringApp extends StatelessWidget {
  final Widget child;
  final ColoringSdkConfiguration configuration;

  const ColoringApp({
    super.key,
    required this.child,
    required this.configuration,
  });

  @override
  Widget build(BuildContext context) {
    final sdkTheme = configuration.theme;

    return MaterialApp(
      onGenerateTitle: (context) =>
          ColoringSdkLocalizationsDelegate.of(context).applicationTitle,
      localizationsDelegates: [
        ColoringSdkLocalizationsDelegate(configuration.localizations),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: const ColorScheme.dark().copyWith(
          surface: sdkTheme.surface.toColor(),
          onSurface: sdkTheme.onSurface.toColor(),
          surfaceContainer: sdkTheme.surfaceContainer.toColor(),
          secondary: sdkTheme.secondary.toColor(),
          tertiary: configuration.initialColor.toColor(),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: sdkTheme.buttonTheme.background.toColor(),
          foregroundColor: sdkTheme.buttonTheme.foreground.toColor(),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
              (_) => sdkTheme.buttonTheme.background.toColor(),
            ),
            textStyle: WidgetStateTextStyle.resolveWith(
              (_) => TextStyle(
                color: sdkTheme.buttonTheme.foreground.toColor(),
              ),
            ),
            iconColor: WidgetStateColor.resolveWith(
              (_) => sdkTheme.buttonTheme.foreground.toColor(),
            ),
          ),
        ),
      ),
      home: child,
    );
  }
}

class ColoringScreen extends StatefulWidget {
  final ColoringHostApi hostApi;
  final ColoringSdkConfiguration configuration;
  final ui.Image image;

  const ColoringScreen({
    required this.hostApi,
    required this.configuration,
    required this.image,
    super.key,
  });

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  late final _drawingController = DrawingController(
    config: DrawConfig.def(
      blendMode: BlendMode.darken,
      contentType: SimpleLine,
    ),
  );

  late final AppLifecycleListener _appLifecycleListener;
  bool _wasSubmitted = false;

  @override
  void initState() {
    super.initState();
    _appLifecycleListener = AppLifecycleListener(
      onDetach: () {
        if (_wasSubmitted) return;

        widget.hostApi.onExitWithoutSubmit(
          jsonEncode(_drawingController.getJsonList()),
        );
      },
    );
    SchedulerBinding.instance.addPostFrameCallback((_) => _init());
  }

  @override
  Widget build(BuildContext context) {
    final localization = ColoringSdkLocalizationsDelegate.of(context);
    final featureToggle = widget.configuration.featureToggle;
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        SystemNavigator.pop(animated: true);
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                localization.screenTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 550,
                width: MediaQuery.sizeOf(context).width,
                child: DrawingBoard(
                  boardScaleEnabled: featureToggle.isScaleEnabled,
                  boardPanEnabled: featureToggle.isPanEnabled,
                  defaultToolsBuilder: _toolsBuilder,
                  defaultActionsBuilder: _actionsBuilder,
                  image: widget.image,
                  showDefaultActions: true,
                  showDefaultTools: true,
                  controller: _drawingController,
                  background: SizedBox(
                    height: 400,
                    width: MediaQuery.sizeOf(context).width,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          children: [
            const SizedBox(width: 40),
            FloatingActionButton(
              onPressed: Navigator.of(context).maybePop,
              tooltip: localization.submitTooltip,
              child: const Icon(Icons.close),
            ),
            const Spacer(),
            FloatingActionButton(
              onPressed: _submit,
              tooltip: localization.submitTooltip,
              child: const Icon(Icons.check),
            ),
            if (featureToggle.isColorPickerEnabled) ...[
              const SizedBox(width: 10),
              FloatingActionButton(
                tooltip: localization.pickColorTooltip,
                onPressed: _pickColor,
                child: AspectListenableBuilder(
                  listenable: _drawingController.drawConfig,
                  aspect: (listenable) => listenable.value.color,
                  buildWhen: (previous, current) => previous != current,
                  builder: (context, value, child) => DecoratedBox(
                    decoration: BoxDecoration(
                      color: value,
                      shape: BoxShape.circle,
                    ),
                    child: LayoutBuilder(
                        builder: (_, constraints) => SizedBox.square(
                            dimension: constraints.maxWidth / 2)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _drawingController.dispose();
    _appLifecycleListener.dispose();
    super.dispose();
  }

  void _init() {
    _drawingController.setStyle(
      color: widget.configuration.initialColor.toColor(),
    );

    final session = widget.configuration.session;
    if (session != null) {
      final contents = PaintContentX.fromJson(session);

      _drawingController.addContents(contents.toList());
    }
  }

  Future<void> _submit() async {
    final data = await _drawingController.getImageData();

    if (data == null) return;

    final bytes = data.buffer.asUint8List();

    await widget.hostApi.onColoringSubmit(bytes);

    _wasSubmitted = true;

    SystemNavigator.pop(animated: true);
  }

  Future<void> _pickColor() async {
    final theme = Theme.of(context);
    final color = await showModalBottomSheet<Color>(
      backgroundColor: theme.colorScheme.surfaceContainer,
      isScrollControlled: true,
      context: context,
      builder: (context) => ColorPicker(
        initialColor: _drawingController.getColor,
        onSubmit: (color) => Navigator.of(context).pop(color),
        onCancel: () => Navigator.of(context).pop(),
        presets: widget.configuration.colorPresets
            .map((c) => c.toColor())
            .whereType<Color>()
            .toList(),
      ),
    );

    if (color == null) return;

    _drawingController.setStyle(color: color);
  }

  List<DefToolItem> _toolsBuilder(Type currType, DrawingController controller) {
    return [
      DefToolItem(
          isActive: currType == SimpleLine,
          icon: Icons.edit,
          onTap: () => controller.setPaintContent(SimpleLine())),
      ...widget.configuration.featureToggle.enabledTools
          .toSet()
          .map((e) => switch (e) {
                ColoringSdkTool.straightLine => DefToolItem(
                    isActive: currType == StraightLine,
                    icon: Icons.show_chart,
                    onTap: () => controller.setPaintContent(StraightLine()),
                  ),
                ColoringSdkTool.rectangle => DefToolItem(
                    isActive: currType == Rectangle,
                    icon: CupertinoIcons.stop,
                    onTap: () => controller.setPaintContent(Rectangle()),
                  ),
                ColoringSdkTool.circle => DefToolItem(
                    isActive: currType == Circle,
                    icon: CupertinoIcons.circle,
                    onTap: () => controller.setPaintContent(Circle()),
                  ),
                ColoringSdkTool.eraser => DefToolItem(
                    isActive: currType == Eraser,
                    icon: CupertinoIcons.bandage,
                    onTap: () => controller.setPaintContent(Eraser()),
                  ),
              })
    ];
  }

  List<Widget> _actionsBuilder(BuildContext context, DrawConfig config) {
    final theme = Theme.of(context);

    return widget.configuration.featureToggle.enabledActions
        .toSet()
        .map((e) => switch (e) {
              ColoringSdkAction.strokeWidth => SizedBox(
                  height: 24,
                  width: 160,
                  child: Slider(
                    thumbColor: theme.colorScheme.onSurface,
                    activeColor: theme.colorScheme.secondary,
                    value: config.strokeWidth,
                    max: 50,
                    min: 1,
                    onChanged: (double v) =>
                        _drawingController.setStyle(strokeWidth: v),
                  ),
                ),
              ColoringSdkAction.undo => IconButton(
                  icon: Icon(
                    CupertinoIcons.arrow_turn_up_left,
                    color: _drawingController.canUndo() ? null : Colors.grey,
                  ),
                  onPressed: () => _drawingController.undo(),
                ),
              ColoringSdkAction.redo => IconButton(
                  icon: Icon(
                    CupertinoIcons.arrow_turn_up_right,
                    color: _drawingController.canRedo() ? null : Colors.grey,
                  ),
                  onPressed: () => _drawingController.redo(),
                ),
              ColoringSdkAction.rotate => IconButton(
                  icon: const Icon(CupertinoIcons.rotate_right),
                  onPressed: () => _drawingController.turn(),
                ),
              ColoringSdkAction.clear => IconButton(
                  icon: const Icon(CupertinoIcons.trash),
                  onPressed: () => _drawingController.clear(),
                ),
            })
        .toList();
  }
}
