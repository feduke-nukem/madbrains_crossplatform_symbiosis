// Autogenerated from Pigeon (v22.4.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

PlatformException _createConnectionError(String channelName) {
  return PlatformException(
    code: 'channel-error',
    message: 'Unable to establish connection on channel: "$channelName".',
  );
}

List<Object?> wrapResponse({Object? result, PlatformException? error, bool empty = false}) {
  if (empty) {
    return <Object?>[];
  }
  if (error == null) {
    return <Object?>[result];
  }
  return <Object?>[error.code, error.message, error.details];
}

class ColoringSdkConfiguration {
  ColoringSdkConfiguration({
    required this.image,
    required this.initialColor,
    this.session,
    required this.colorPresets,
    required this.localizations,
    required this.theme,
  });

  Uint8List image;

  /// Hex format.
  String initialColor;

  /// Json format.
  ///
  /// Only could be used from previously saved session [HostApi.onExitWithoutSubmit]
  ///
  /// or from [FlutterColoringApi.getSession].
  String? session;

  /// Hex format.
  List<String> colorPresets;

  ColoringSdkLocalizations localizations;

  ColoringSdkTheme theme;

  Object encode() {
    return <Object?>[
      image,
      initialColor,
      session,
      colorPresets,
      localizations,
      theme,
    ];
  }

  static ColoringSdkConfiguration decode(Object result) {
    result as List<Object?>;
    return ColoringSdkConfiguration(
      image: result[0]! as Uint8List,
      initialColor: result[1]! as String,
      session: result[2] as String?,
      colorPresets: (result[3] as List<Object?>?)!.cast<String>(),
      localizations: result[4]! as ColoringSdkLocalizations,
      theme: result[5]! as ColoringSdkTheme,
    );
  }
}

class ColoringSdkLocalizations {
  ColoringSdkLocalizations({
    required this.applicationTitle,
    required this.submitTooltip,
    required this.pickColorTooltip,
    required this.colorPickerTitle,
    required this.colorPickerPresetsTitle,
    required this.screenTitle,
  });

  String applicationTitle;

  String submitTooltip;

  String pickColorTooltip;

  String colorPickerTitle;

  String colorPickerPresetsTitle;

  String screenTitle;

  Object encode() {
    return <Object?>[
      applicationTitle,
      submitTooltip,
      pickColorTooltip,
      colorPickerTitle,
      colorPickerPresetsTitle,
      screenTitle,
    ];
  }

  static ColoringSdkLocalizations decode(Object result) {
    result as List<Object?>;
    return ColoringSdkLocalizations(
      applicationTitle: result[0]! as String,
      submitTooltip: result[1]! as String,
      pickColorTooltip: result[2]! as String,
      colorPickerTitle: result[3]! as String,
      colorPickerPresetsTitle: result[4]! as String,
      screenTitle: result[5]! as String,
    );
  }
}

class ColoringSdkTheme {
  ColoringSdkTheme({
    required this.surface,
    required this.onSurface,
    required this.surfaceContainer,
    required this.secondary,
    required this.buttonTheme,
  });

  /// Hex format.
  String surface;

  /// Hex format.
  String onSurface;

  /// Hex format.
  String surfaceContainer;

  /// Hex format.
  String secondary;

  ColoringSdkButtonTheme buttonTheme;

  Object encode() {
    return <Object?>[
      surface,
      onSurface,
      surfaceContainer,
      secondary,
      buttonTheme,
    ];
  }

  static ColoringSdkTheme decode(Object result) {
    result as List<Object?>;
    return ColoringSdkTheme(
      surface: result[0]! as String,
      onSurface: result[1]! as String,
      surfaceContainer: result[2]! as String,
      secondary: result[3]! as String,
      buttonTheme: result[4]! as ColoringSdkButtonTheme,
    );
  }
}

class ColoringSdkButtonTheme {
  ColoringSdkButtonTheme({
    required this.background,
    required this.foreground,
  });

  /// Hex format.
  String background;

  /// Hex format.
  String foreground;

  Object encode() {
    return <Object?>[
      background,
      foreground,
    ];
  }

  static ColoringSdkButtonTheme decode(Object result) {
    result as List<Object?>;
    return ColoringSdkButtonTheme(
      background: result[0]! as String,
      foreground: result[1]! as String,
    );
  }
}


class _PigeonCodec extends StandardMessageCodec {
  const _PigeonCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is int) {
      buffer.putUint8(4);
      buffer.putInt64(value);
    }    else if (value is ColoringSdkConfiguration) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    }    else if (value is ColoringSdkLocalizations) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    }    else if (value is ColoringSdkTheme) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    }    else if (value is ColoringSdkButtonTheme) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 129: 
        return ColoringSdkConfiguration.decode(readValue(buffer)!);
      case 130: 
        return ColoringSdkLocalizations.decode(readValue(buffer)!);
      case 131: 
        return ColoringSdkTheme.decode(readValue(buffer)!);
      case 132: 
        return ColoringSdkButtonTheme.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class FlutterColoringApi {
  static const MessageCodec<Object?> pigeonChannelCodec = _PigeonCodec();

  void onConfigurationProvided(ColoringSdkConfiguration configuration);

  static void setUp(FlutterColoringApi? api, {BinaryMessenger? binaryMessenger, String messageChannelSuffix = '',}) {
    messageChannelSuffix = messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
    {
      final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.coloring_api.FlutterColoringApi.onConfigurationProvided$messageChannelSuffix', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        pigeonVar_channel.setMessageHandler(null);
      } else {
        pigeonVar_channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.coloring_api.FlutterColoringApi.onConfigurationProvided was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ColoringSdkConfiguration? arg_configuration = (args[0] as ColoringSdkConfiguration?);
          assert(arg_configuration != null,
              'Argument for dev.flutter.pigeon.coloring_api.FlutterColoringApi.onConfigurationProvided was null, expected non-null ColoringSdkConfiguration.');
          try {
            api.onConfigurationProvided(arg_configuration!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
  }
}

class ColoringHostApi {
  /// Constructor for [ColoringHostApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  ColoringHostApi({BinaryMessenger? binaryMessenger, String messageChannelSuffix = ''})
      : pigeonVar_binaryMessenger = binaryMessenger,
        pigeonVar_messageChannelSuffix = messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
  final BinaryMessenger? pigeonVar_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = _PigeonCodec();

  final String pigeonVar_messageChannelSuffix;

  /// Json format.
  Future<void> onExitWithoutSubmit(String session) async {
    final String pigeonVar_channelName = 'dev.flutter.pigeon.coloring_api.ColoringHostApi.onExitWithoutSubmit$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(<Object?>[session]) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> onColoringSubmit(Uint8List image) async {
    final String pigeonVar_channelName = 'dev.flutter.pigeon.coloring_api.ColoringHostApi.onColoringSubmit$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(<Object?>[image]) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return;
    }
  }
}