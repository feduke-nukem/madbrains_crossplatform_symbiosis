// Autogenerated from Pigeon (v22.4.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation

#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

/// Error class for passing custom error details to Dart side.
public final class PigeonError: Error {
    let code: String
    let message: String?
    let details: Any?

    public init(code: String, message: String?, details: Any?) {
        self.code = code
        self.message = message
        self.details = details
    }

    var localizedDescription: String {
        return
            "PigeonError(code: \(self.code), message: \(self.message ?? "<nil>"), details: \(self.details ?? "<nil>")"
    }
}

private func wrapResult(_ result: Any?) -> [Any?] {
    return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
    if let pigeonError = error as? PigeonError {
        return [
            pigeonError.code,
            pigeonError.message,
            pigeonError.details,
        ]
    }
    if let flutterError = error as? FlutterError {
        return [
            flutterError.code,
            flutterError.message,
            flutterError.details,
        ]
    }
    return [
        "\(error)",
        "\(type(of: error))",
        "Stacktrace: \(Thread.callStackSymbols)",
    ]
}

private func createConnectionError(withChannelName channelName: String) -> PigeonError {
    return PigeonError(code: "channel-error", message: "Unable to establish connection on channel: '\(channelName)'.", details: "")
}

private func isNullish(_ value: Any?) -> Bool {
    return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
    if value is NSNull { return nil }
    return value as! T?
}

public enum ColoringSdkTool: Int {
    case straightLine = 0
    case rectangle = 1
    case circle = 2
    case eraser = 3
}

public enum ColoringSdkAction: Int {
    case strokeWidth = 0
    case undo = 1
    case redo = 2
    case rotate = 3
    case clear = 4
}

/// Generated class from Pigeon that represents data sent in messages.
public struct ColoringSdkConfiguration {
    var image: FlutterStandardTypedData
    /// Hex format.
    var initialColor: String
    /// Json format.
    ///
    /// Only could be used from previously saved session [HostApi.onExitWithoutSubmit]
    ///
    /// or from [FlutterColoringApi.getSession].
    var session: String?
    /// Hex format.
    var colorPresets: [String]
    var localizations: ColoringSdkLocalizations
    var theme: ColoringSdkTheme
    var featureToggle: ColoringSdkFeatureToggle

    public init(image: FlutterStandardTypedData, initialColor: String, session: String? = nil, colorPresets: [String], localizations: ColoringSdkLocalizations, theme: ColoringSdkTheme, featureToggle: ColoringSdkFeatureToggle) {
        self.image = image
        self.initialColor = initialColor
        self.session = session
        self.colorPresets = colorPresets
        self.localizations = localizations
        self.theme = theme
        self.featureToggle = featureToggle
    }

    // swift-format-ignore: AlwaysUseLowerCamelCase
    static func fromList(_ pigeonVar_list: [Any?]) -> ColoringSdkConfiguration? {
        let image = pigeonVar_list[0] as! FlutterStandardTypedData
        let initialColor = pigeonVar_list[1] as! String
        let session: String? = nilOrValue(pigeonVar_list[2])
        let colorPresets = pigeonVar_list[3] as! [String]
        let localizations = pigeonVar_list[4] as! ColoringSdkLocalizations
        let theme = pigeonVar_list[5] as! ColoringSdkTheme
        let featureToggle = pigeonVar_list[6] as! ColoringSdkFeatureToggle

        return ColoringSdkConfiguration(
            image: image,
            initialColor: initialColor,
            session: session,
            colorPresets: colorPresets,
            localizations: localizations,
            theme: theme,
            featureToggle: featureToggle
        )
    }

    func toList() -> [Any?] {
        return [
            self.image,
            self.initialColor,
            self.session,
            self.colorPresets,
            self.localizations,
            self.theme,
            self.featureToggle,
        ]
    }
}

/// Generated class from Pigeon that represents data sent in messages.
public struct ColoringSdkLocalizations {
    var applicationTitle: String
    var submitTooltip: String
    var pickColorTooltip: String
    var colorPickerTitle: String
    var colorPickerPresetsTitle: String
    var screenTitle: String

    public init(applicationTitle: String, submitTooltip: String, pickColorTooltip: String, colorPickerTitle: String, colorPickerPresetsTitle: String, screenTitle: String) {
        self.applicationTitle = applicationTitle
        self.submitTooltip = submitTooltip
        self.pickColorTooltip = pickColorTooltip
        self.colorPickerTitle = colorPickerTitle
        self.colorPickerPresetsTitle = colorPickerPresetsTitle
        self.screenTitle = screenTitle
    }

    // swift-format-ignore: AlwaysUseLowerCamelCase
    static func fromList(_ pigeonVar_list: [Any?]) -> ColoringSdkLocalizations? {
        let applicationTitle = pigeonVar_list[0] as! String
        let submitTooltip = pigeonVar_list[1] as! String
        let pickColorTooltip = pigeonVar_list[2] as! String
        let colorPickerTitle = pigeonVar_list[3] as! String
        let colorPickerPresetsTitle = pigeonVar_list[4] as! String
        let screenTitle = pigeonVar_list[5] as! String

        return ColoringSdkLocalizations(
            applicationTitle: applicationTitle,
            submitTooltip: submitTooltip,
            pickColorTooltip: pickColorTooltip,
            colorPickerTitle: colorPickerTitle,
            colorPickerPresetsTitle: colorPickerPresetsTitle,
            screenTitle: screenTitle
        )
    }

    func toList() -> [Any?] {
        return [
            self.applicationTitle,
            self.submitTooltip,
            self.pickColorTooltip,
            self.colorPickerTitle,
            self.colorPickerPresetsTitle,
            self.screenTitle,
        ]
    }
}

/// Generated class from Pigeon that represents data sent in messages.
public struct ColoringSdkTheme {
    /// Hex format.
    var surface: String
    /// Hex format.
    var onSurface: String
    /// Hex format.
    var surfaceContainer: String
    /// Hex format.
    var secondary: String
    var buttonTheme: ColoringSdkButtonTheme

    public init(surface: String, onSurface: String, surfaceContainer: String, secondary: String, buttonTheme: ColoringSdkButtonTheme) {
        self.surface = surface
        self.onSurface = onSurface
        self.surfaceContainer = surfaceContainer
        self.secondary = secondary
        self.buttonTheme = buttonTheme
    }

    // swift-format-ignore: AlwaysUseLowerCamelCase
    static func fromList(_ pigeonVar_list: [Any?]) -> ColoringSdkTheme? {
        let surface = pigeonVar_list[0] as! String
        let onSurface = pigeonVar_list[1] as! String
        let surfaceContainer = pigeonVar_list[2] as! String
        let secondary = pigeonVar_list[3] as! String
        let buttonTheme = pigeonVar_list[4] as! ColoringSdkButtonTheme

        return ColoringSdkTheme(
            surface: surface,
            onSurface: onSurface,
            surfaceContainer: surfaceContainer,
            secondary: secondary,
            buttonTheme: buttonTheme
        )
    }

    func toList() -> [Any?] {
        return [
            self.surface,
            self.onSurface,
            self.surfaceContainer,
            self.secondary,
            self.buttonTheme,
        ]
    }
}

/// Generated class from Pigeon that represents data sent in messages.
public struct ColoringSdkButtonTheme {
    /// Hex format.
    var background: String
    /// Hex format.
    var foreground: String

    public init(background: String, foreground: String) {
        self.background = background
        self.foreground = foreground
    }

    // swift-format-ignore: AlwaysUseLowerCamelCase
    static func fromList(_ pigeonVar_list: [Any?]) -> ColoringSdkButtonTheme? {
        let background = pigeonVar_list[0] as! String
        let foreground = pigeonVar_list[1] as! String

        return ColoringSdkButtonTheme(
            background: background,
            foreground: foreground
        )
    }

    func toList() -> [Any?] {
        return [
            self.background,
            self.foreground,
        ]
    }
}

/// Generated class from Pigeon that represents data sent in messages.
public struct ColoringSdkFeatureToggle {
    var isColorPickerEnabled: Bool
    var isScaleEnabled: Bool
    var isPanEnabled: Bool
    var enabledTools: [ColoringSdkTool]
    var enabledActions: [ColoringSdkAction]

    public init(isColorPickerEnabled: Bool, isScaleEnabled: Bool, isPanEnabled: Bool, enabledTools: [ColoringSdkTool], enabledActions: [ColoringSdkAction]) {
        self.isColorPickerEnabled = isColorPickerEnabled
        self.isScaleEnabled = isScaleEnabled
        self.isPanEnabled = isPanEnabled
        self.enabledTools = enabledTools
        self.enabledActions = enabledActions
    }

    // swift-format-ignore: AlwaysUseLowerCamelCase
    static func fromList(_ pigeonVar_list: [Any?]) -> ColoringSdkFeatureToggle? {
        let isColorPickerEnabled = pigeonVar_list[0] as! Bool
        let isScaleEnabled = pigeonVar_list[1] as! Bool
        let isPanEnabled = pigeonVar_list[2] as! Bool
        let enabledTools = pigeonVar_list[3] as! [ColoringSdkTool]
        let enabledActions = pigeonVar_list[4] as! [ColoringSdkAction]

        return ColoringSdkFeatureToggle(
            isColorPickerEnabled: isColorPickerEnabled,
            isScaleEnabled: isScaleEnabled,
            isPanEnabled: isPanEnabled,
            enabledTools: enabledTools,
            enabledActions: enabledActions
        )
    }

    func toList() -> [Any?] {
        return [
            self.isColorPickerEnabled,
            self.isScaleEnabled,
            self.isPanEnabled,
            self.enabledTools,
            self.enabledActions,
        ]
    }
}

private class apiPigeonCodecReader: FlutterStandardReader {
    override func readValue(ofType type: UInt8) -> Any? {
        switch type {
        case 129:
            let enumResultAsInt: Int? = nilOrValue(self.readValue() as! Int?)
            if let enumResultAsInt = enumResultAsInt {
                return ColoringSdkTool(rawValue: enumResultAsInt)
            }
            return nil
        case 130:
            let enumResultAsInt: Int? = nilOrValue(self.readValue() as! Int?)
            if let enumResultAsInt = enumResultAsInt {
                return ColoringSdkAction(rawValue: enumResultAsInt)
            }
            return nil
        case 131:
            return ColoringSdkConfiguration.fromList(self.readValue() as! [Any?])
        case 132:
            return ColoringSdkLocalizations.fromList(self.readValue() as! [Any?])
        case 133:
            return ColoringSdkTheme.fromList(self.readValue() as! [Any?])
        case 134:
            return ColoringSdkButtonTheme.fromList(self.readValue() as! [Any?])
        case 135:
            return ColoringSdkFeatureToggle.fromList(self.readValue() as! [Any?])
        default:
            return super.readValue(ofType: type)
        }
    }
}

private class apiPigeonCodecWriter: FlutterStandardWriter {
    override func writeValue(_ value: Any) {
        if let value = value as? ColoringSdkTool {
            super.writeByte(129)
            super.writeValue(value.rawValue)
        } else if let value = value as? ColoringSdkAction {
            super.writeByte(130)
            super.writeValue(value.rawValue)
        } else if let value = value as? ColoringSdkConfiguration {
            super.writeByte(131)
            super.writeValue(value.toList())
        } else if let value = value as? ColoringSdkLocalizations {
            super.writeByte(132)
            super.writeValue(value.toList())
        } else if let value = value as? ColoringSdkTheme {
            super.writeByte(133)
            super.writeValue(value.toList())
        } else if let value = value as? ColoringSdkButtonTheme {
            super.writeByte(134)
            super.writeValue(value.toList())
        } else if let value = value as? ColoringSdkFeatureToggle {
            super.writeByte(135)
            super.writeValue(value.toList())
        } else {
            super.writeValue(value)
        }
    }
}

private class apiPigeonCodecReaderWriter: FlutterStandardReaderWriter {
    override func reader(with data: Data) -> FlutterStandardReader {
        return apiPigeonCodecReader(data: data)
    }

    override func writer(with data: NSMutableData) -> FlutterStandardWriter {
        return apiPigeonCodecWriter(data: data)
    }
}

class apiPigeonCodec: FlutterStandardMessageCodec, @unchecked Sendable {
    static let shared = apiPigeonCodec(readerWriter: apiPigeonCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents Flutter messages that can be called from Swift.
protocol FlutterColoringApiProtocol {
    func provideConfiguration(configuration configurationArg: ColoringSdkConfiguration, completion: @escaping (Result<Void, PigeonError>) -> Void)
}

public class FlutterColoringApi: FlutterColoringApiProtocol {
    private let binaryMessenger: FlutterBinaryMessenger
    private let messageChannelSuffix: String
    public init(binaryMessenger: FlutterBinaryMessenger, messageChannelSuffix: String = "") {
        self.binaryMessenger = binaryMessenger
        self.messageChannelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
    }

    var codec: apiPigeonCodec {
        return apiPigeonCodec.shared
    }

    func provideConfiguration(configuration configurationArg: ColoringSdkConfiguration, completion: @escaping (Result<Void, PigeonError>) -> Void) {
        let channelName = "dev.flutter.pigeon.coloring_api.FlutterColoringApi.provideConfiguration\(messageChannelSuffix)"
        let channel = FlutterBasicMessageChannel(name: channelName, binaryMessenger: binaryMessenger, codec: codec)
        channel.sendMessage([configurationArg] as [Any?]) { response in
            guard let listResponse = response as? [Any?] else {
                completion(.failure(createConnectionError(withChannelName: channelName)))
                return
            }
            if listResponse.count > 1 {
                let code: String = listResponse[0] as! String
                let message: String? = nilOrValue(listResponse[1])
                let details: String? = nilOrValue(listResponse[2])
                completion(.failure(PigeonError(code: code, message: message, details: details)))
            } else {
                completion(.success(()))
            }
        }
    }
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
public protocol ColoringHostApi {
    /// Json format.
    func onExitWithoutSubmit(session: String) throws
    func onColoringSubmit(image: FlutterStandardTypedData) throws
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
public class ColoringHostApiSetup {
    static var codec: FlutterStandardMessageCodec { apiPigeonCodec.shared }
    /// Sets up an instance of `ColoringHostApi` to handle messages through the `binaryMessenger`.
    static func setUp(binaryMessenger: FlutterBinaryMessenger, api: ColoringHostApi?, messageChannelSuffix: String = "") {
        let channelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
        /// Json format.
        let onExitWithoutSubmitChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.coloring_api.ColoringHostApi.onExitWithoutSubmit\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
        if let api = api {
            onExitWithoutSubmitChannel.setMessageHandler { message, reply in
                let args = message as! [Any?]
                let sessionArg = args[0] as! String
                do {
                    try api.onExitWithoutSubmit(session: sessionArg)
                    reply(wrapResult(nil))
                } catch {
                    reply(wrapError(error))
                }
            }
        } else {
            onExitWithoutSubmitChannel.setMessageHandler(nil)
        }
        let onColoringSubmitChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.coloring_api.ColoringHostApi.onColoringSubmit\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
        if let api = api {
            onColoringSubmitChannel.setMessageHandler { message, reply in
                let args = message as! [Any?]
                let imageArg = args[0] as! FlutterStandardTypedData
                do {
                    try api.onColoringSubmit(image: imageArg)
                    reply(wrapResult(nil))
                } catch {
                    reply(wrapError(error))
                }
            }
        } else {
            onColoringSubmitChannel.setMessageHandler(nil)
        }
    }
}
