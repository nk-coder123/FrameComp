//
//  SettingsView.swift
//  FrameComp
//
//  Settings sheet for overlay appearance and defaults.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: UserSettings
    @Environment(\.dismiss) var dismiss

    private let colors = ["#FFFFFF", "#000000", "#FF0000", "#FFFF00", "#00FFFF", "custom"]
    private let colorNames = ["White", "Black", "Red", "Yellow", "Cyan", "Custom"]
    private let lineWeights: [(String, CGFloat)] = [("Thin", 0.5), ("Normal", 1.0), ("Thick", 2.0)]

    private var customColor: Color {
        Color(hex: settings.overlayColorHex)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Overlay Appearance") {
                    Picker("Color", selection: Binding(
                        get: { colors.dropLast().contains(settings.overlayColorHex) ? settings.overlayColorHex : "custom" },
                        set: { if $0 != "custom" { settings.overlayColorHex = $0 }; settings.save() }
                    )) {
                        ForEach(Array(colors.enumerated()), id: \.offset) { i, hex in
                            Text(colorNames[i]).tag(hex)
                        }
                    }
                    if !colors.dropLast().contains(settings.overlayColorHex) {
                        ColorPicker("Custom Color", selection: Binding(
                            get: { customColor },
                            set: { settings.overlayColorHex = $0.toHex(); settings.save() }
                        ))
                    }
                    Picker("Line Weight", selection: Binding(
                        get: { settings.overlayLineWeight },
                        set: { settings.overlayLineWeight = $0; settings.save() }
                    )) {
                        ForEach(lineWeights, id: \.1) { name, weight in
                            Text(name).tag(weight)
                        }
                    }
                    Slider(value: Binding(
                        get: { settings.overlayOpacity },
                        set: { settings.overlayOpacity = $0; settings.save() }
                    ), in: 0.2...1, step: 0.05)
                    Text("Opacity: \(Int(settings.overlayOpacity * 100))%")
                }
                Section("Defaults") {
                    Picker("Default Aspect Ratio", selection: Binding(
                        get: { settings.defaultAspectRatio },
                        set: { settings.defaultAspectRatio = $0; settings.save() }
                    )) {
                        ForEach(AspectRatio.allCases, id: \.self) { ratio in
                            Text(ratio.displayName).tag(ratio)
                        }
                    }
                    Picker("Default Guide", selection: Binding(
                        get: { settings.defaultGuide },
                        set: { settings.defaultGuide = $0; settings.save() }
                    )) {
                        ForEach(GuideType.allCases, id: \.self) { guide in
                            Text(guide.overlay.displayName).tag(guide)
                        }
                    }
                }
                Section("Options") {
                    Toggle("Show Power Points", isOn: Binding(
                        get: { settings.showPowerPoints },
                        set: { settings.showPowerPoints = $0; settings.save() }
                    ))
                    Toggle("Haptic Feedback", isOn: Binding(
                        get: { settings.hapticEnabled },
                        set: { settings.hapticEnabled = $0; settings.save() }
                    ))
                }
                if settings.selectedGuide == .customGrid {
                    Section("Custom Grid") {
                        Stepper("Columns: \(settings.customGridColumns)", value: Binding(
                            get: { settings.customGridColumns },
                            set: { settings.customGridColumns = min(24, max(2, $0)); settings.save() }
                        ), in: 2...24)
                        Stepper("Rows: \(settings.customGridRows)", value: Binding(
                            get: { settings.customGridRows },
                            set: { settings.customGridRows = min(24, max(2, $0)); settings.save() }
                        ), in: 2...24)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
