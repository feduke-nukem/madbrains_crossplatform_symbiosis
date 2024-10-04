//
//  ContentView.swift
//  ColoringPagesIos
//
//  Created by Фёдор Благодырь on 22.09.2024.
//

import coloring_api
import Flutter
import SwiftUI

let attackOnTitan = "AttackOnTitan"
let chadShrek = "ChadShrek"
let spawn = "Spawn"
let spiderMan = "SpiderMan"
let hellBoy = "HellBoy"

// MARK: - LocalImagesList

struct LocalImagesList: View {
    let images: [String] = [
        attackOnTitan,
        chadShrek,
        spawn,
        spiderMan,
        hellBoy,
    ] // Image names in Assets folder

    let onAssetSelect: (String) -> Void

    var body: some View {
        ScrollView {
            VStack {
                ForEach(images, id: \.self) { imageName in
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .padding()
                        .onTapGesture {
                            onAssetSelect(imageName) // Handle image selection
                        }
                }
            }
        }
    }
}

// MARK: - ContentView

struct ContentView: View {
    @State private var selectedAsset: String?
    @State private var resultImage: UIImage?
    @State private var sessions = [String: String]()

    var body: some View {
        NavigationStack {
            ZStack {
                LocalImagesList { image in
                    selectedAsset = image
                }
                .navigationTitle("Select image to color!")

                if let resultImage = resultImage {
                    ModalImageView(
                        resultImage: resultImage,
                        onClose: {
                            self.resultImage = nil
                        }
                    )
                }
            }
            .navigationDestination(isPresented: .constant(selectedAsset != nil)) {
                if let selectedImageName = selectedAsset,
                   let image = UIImage(named: selectedImageName)
                {
                    FlutterModuleRepresentable(
                        hostApiHandler: HostApiHandler(
                            onResult: { data in
                                self.selectedAsset = nil
                                if let result = UIImage(data: data) {
                                    resultImage = result // Show result image in modal
                                }
                                sessions.removeValue(forKey: selectedImageName)
                            },
                            onExit: { session in
                                sessions[selectedImageName] = session
                            }
                        ),
                        configuration: ColoringSdkConfiguration(
                            image: FlutterStandardTypedData(bytes: image.pngData()!),
                            initialColor: initialColor(imageName: selectedImageName),
                            session: sessions[selectedImageName],
                            colorPresets: [
                                "#ffffff",
                                "#030303",
                                "#5c4ede",
                                "#1c1273",
                                "#dff291",
                                "#f59e14",
                                "#ff30c1",
                            ],
                            localizations: ColoringSdkLocalizations(
                                applicationTitle: "Coloring pages",
                                submitTooltip: "Submit and share!",
                                pickColorTooltip: "Pick your very own color!",
                                colorPickerTitle: "Pick your color!",
                                colorPickerPresetsTitle: "Available color presets",
                                screenTitle: screenTitle(imageName: selectedImageName)
                            ),
                            theme: ColoringSdkTheme(
                                surface: "#FFFFFF",
                                onSurface: "#000000",
                                surfaceContainer: "#e1eaeb",
                                secondary: "#45c8cc",
                                buttonTheme: ColoringSdkButtonTheme(
                                    background: "#e1eaeb",
                                    foreground: "#000000"
                                )
                            ),
                            featureToggle: ColoringSdkFeatureToggle(
                                isColorPickerEnabled: true,
                                isScaleEnabled: true,
                                isPanEnabled: true,
                                enabledTools: [
                                    .circle,
                                    .eraser,
                                    .rectangle,
                                    .straightLine,
                                ],
                                enabledActions: [
                                    .strokeWidth,
                                    .undo,
                                    .redo,
                                    .rotate,
                                    .clear,
                                ]
                            )
                        )
                    )
                    .onDisappear {
                        self.selectedAsset = nil
                    }
                }
            }
        }
    }

    func initialColor(imageName: String) -> String {
        switch imageName {
        case attackOnTitan: return "#c97979"
        case chadShrek: return "8cc979"
        case hellBoy: return "#a30a0a"
        case spawn: return "#000000"
        case spiderMan: return "#ff0000"
        default:
            return "#1900ff"
        }
    }

    func screenTitle(imageName: String) -> String {
        switch imageName {
        case attackOnTitan: return "Eren Yeager"
        case chadShrek: return "Shrek"
        case hellBoy: return "Hellboy"
        case spawn: return "Spawn"
        case spiderMan: return "Spider-man"
        default:
            return "Color this one!"
        }
    }
}

// MARK: - ModalImageView

struct ModalImageView: View {
    let resultImage: UIImage
    let onClose: () -> Void

    var body: some View {
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack {
                    Image(uiImage: resultImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 300)

                    HStack {
                        CloseButton(action: onClose)
                        ShareButton(image: resultImage)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(40)
            )
    }
}

// MARK: - CloseButton

struct CloseButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Close")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.red, Color.red.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(10)
                .shadow(color: Color.red.opacity(0.5), radius: 5, x: 0, y: 5)
        }
    }
}

// MARK: - ShareButton

struct ShareButton: View {
    let image: UIImage

    var body: some View {
        if let imageData = image.pngData() {
            let shareItem = ColoredImage(image: Image(uiImage: image), caption: "Share colored image")
            ShareLink(item: shareItem, preview: SharePreview(shareItem.caption, image: shareItem.image)) {
                Text("Share")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                    )
                    .cornerRadius(10)
                    .shadow(color: Color.blue.opacity(0.5), radius: 5, x: 0, y: 5)
            }
        }
    }
}

// MARK: - HostApiHandler

class HostApiHandler: ColoringHostApi {
    private let onResult: (Data) -> Void
    private let onExit: (String) -> Void

    init(onResult: @escaping (Data) -> Void, onExit: @escaping (String) -> Void) {
        self.onResult = onResult
        self.onExit = onExit
    }

    func onExitWithoutSubmit(session: String) throws {
        onExit(session)
    }

    func onColoringSubmit(image: FlutterStandardTypedData) throws {
        onResult(image.data)
    }
}

// MARK: - FlutterModuleRepresentable

struct FlutterModuleRepresentable: UIViewControllerRepresentable {
    let hostApiHandler: HostApiHandler
    let configuration: ColoringSdkConfiguration

    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = try! ColoringSdk.shared.createViewController(
            hostApiHandler: hostApiHandler,
            configuration: configuration
        )

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

// MARK: - ColoredImage

struct ColoredImage: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }

    public var image: Image
    public var caption: String
}

// MARK: - Preview

#Preview {
    ContentView()
}
