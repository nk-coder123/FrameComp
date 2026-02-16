//
//  LensPickerView.swift
//  FrameComp
//
//  Half-sheet lens selection with presets + custom slider.
//

import SwiftUI
import Combine

struct LensPickerView: View {
    @ObservedObject var settings: UserSettings
    @Environment(\.dismiss) var dismiss

    @State private var customFocalLength: CGFloat = 23
    @State private var debounceTask: Task<Void, Never>?

    var body: some View {
        NavigationStack {
            List {
                ForEach(LensProfile.LensCategory.allCases, id: \.self) { category in
                    let presets = LensProfile.presets.filter { $0.category == category }
                    if !presets.isEmpty {
                        Section(category.displayName) {
                            ForEach(presets) { preset in
                                    Button {
                                        settings.selectedLensFocalLength = preset.focalLengthMM
                                        settings.save()
                                        dismiss()
                                    } label: {
                                        HStack {
                                            Text(preset.displayName)
                                            Spacer()
                                            if settings.selectedLensFocalLength == preset.focalLengthMM {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
                Section("Custom Focal Length") {
                    HStack {
                        TextField("mm", value: $customFocalLength, format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                        Slider(value: $customFocalLength, in: 8...600, step: 1)
                            .onChange(of: customFocalLength) { _, newValue in
                                let value = min(600, max(8, newValue))
                                if value != newValue { customFocalLength = value }
                                debounceTask?.cancel()
                                debounceTask = Task {
                                    try? await Task.sleep(nanoseconds: 100_000_000)
                                    guard !Task.isCancelled else { return }
                                    await MainActor.run {
                                        settings.selectedLensFocalLength = value
                                        settings.save()
                                    }
                                }
                            }
                    }
                }
                Section {
                    let equiv = FOVMatcher.equivalentFocalLength(fujiFocalMM: settings.selectedLensFocalLength)
                    let fov = FOVMatcher.horizontalFOV(focalLengthMM: settings.selectedLensFocalLength)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("35mm equivalent: \(Int(equiv)) mm")
                        Text("Horizontal FOV: \(String(format: "%.1f", fov))°")
                    }
                }
            }
            .navigationTitle("Select Lens")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                customFocalLength = settings.selectedLensFocalLength
            }
        }
    }
}

extension LensProfile.LensCategory {
    var displayName: String {
        switch self {
        case .ultraWide: return "Ultra-Wide"
        case .wide: return "Wide"
        case .standard: return "Standard"
        case .shortTele: return "Short Tele"
        case .telephoto: return "Telephoto"
        }
    }
}
