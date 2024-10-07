//
//  ColoringSdk.swift
//  coloring_api
//
//  Created by Фёдор Благодырь on 23.09.2024.
//

import Flutter
import Foundation

public class ColoringSdk {
    public static let shared = ColoringSdk()

    var flutterEngine: FlutterEngine?

    public func createViewController(
        hostApiHandler: ColoringHostApi,
        configuration: ColoringSdkConfiguration
    ) throws -> UIViewController {
        let needRegisterPlugins = flutterEngine == nil
        do {
            try configuration.validate()
        }
        let engine = createFlutterEngine()
        ColoringHostApiSetup.setUp(binaryMessenger: engine.binaryMessenger, api: hostApiHandler)
        FlutterColoringApi(binaryMessenger: engine.binaryMessenger).provideConfiguration(configuration: configuration) { _ in }
        let controller = FlutterViewController(engine: engine, nibName: nil, bundle: nil)

        if needRegisterPlugins {
            if let pluginRegistrantClass = NSClassFromString("GeneratedPluginRegistrant") as? NSObject.Type {
                let selector = NSSelectorFromString("registerWithRegistry:")

                if pluginRegistrantClass.responds(to: selector) {
                    pluginRegistrantClass.perform(selector, with: controller.pluginRegistry())
                }
            }
        }

        return controller
    }

    func createFlutterEngine() -> FlutterEngine {
        if flutterEngine == nil {
            flutterEngine = FlutterEngine()
            flutterEngine!.run(withEntrypoint: "colorImage")
        }

        return flutterEngine!
    }
}

func isValidHexColor(_ color: String) -> Bool {
    // Regular expression to match a string that starts with '#' and has 3, 6, or 8 hex digits
    let hexColorPattern = "^#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$"
    let regex = try? NSRegularExpression(pattern: hexColorPattern)
    let range = NSRange(location: 0, length: color.utf16.count)

    return regex?.firstMatch(in: color, options: [], range: range) != nil
}

func isValidImage(data: Data) -> Bool {
    return UIImage(data: data) != nil
}

func validateHexColors<T>(_ object: T, prefix: String = "") -> [String] {
    var invalidFields = [String]()

    let mirror = Mirror(reflecting: object)

    for child in mirror.children {
        guard let label = child.label else { continue }
        let value = child.value

        if let stringValue = value as? String {
            if !isValidHexColor(stringValue) {
                invalidFields.append("\(prefix)\(label)")
            }
        } else if !(value is Int || value is Float || value is Double) {
            // Check for nested custom types
            invalidFields.append(contentsOf: validateHexColors(value, prefix: "\(prefix)\(label)."))
        }
    }

    return invalidFields
}

extension ColoringSdkConfiguration {
    func validate() throws {
        guard isValidHexColor(initialColor) else {
            throw IllegalArgumentError.invalidArgument(reason: "invalid initialColor: \(initialColor)")
        }

        for preset in colorPresets {
            guard isValidHexColor(preset) else {
                throw IllegalArgumentError.invalidArgument(reason: "invalid preset: \(preset)")
            }
        }

        guard isValidImage(data: image.data) else {
            throw IllegalArgumentError.invalidArgument(reason: "invalid initialImage: \(image)")
        }

        let invalidColors = validateHexColors(theme)

        if !invalidColors.isEmpty {
            throw IllegalArgumentError.invalidArgument(reason: "invalid theme colors: \(invalidColors.joined(separator: ", "))")
        }
    }
}

enum IllegalArgumentError: Error {
    case invalidArgument(reason: String)
}
