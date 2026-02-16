//
//  UserSettings.swift
//  FrameComp
//
//  Persistent settings via UserDefaults.
//

import Foundation
import Combine
import CoreGraphics

struct UserSettingsCodable: Codable {
    var selectedLensFocalLength: CGFloat
    var selectedAspectRatio: AspectRatio
    var selectedGuide: GuideType
    var guideOrientation: Int
    var overlayColorHex: String
    var overlayOpacity: CGFloat
    var overlayLineWeight: CGFloat
    var showPowerPoints: Bool
    var customGridColumns: Int
    var customGridRows: Int
    var hapticEnabled: Bool
    var defaultAspectRatio: AspectRatio
    var defaultGuide: GuideType
}

final class UserSettings: ObservableObject {
    @Published var selectedLensFocalLength: CGFloat = 23.0
    @Published var selectedAspectRatio: AspectRatio = .threeByTwo
    @Published var selectedGuide: GuideType = .ruleOfThirds
    @Published var guideOrientation: Int = 0
    @Published var overlayColorHex: String = "#FFFFFF"
    @Published var overlayOpacity: CGFloat = 0.6
    @Published var overlayLineWeight: CGFloat = 1.0
    @Published var showPowerPoints: Bool = true
    @Published var customGridColumns: Int = 6
    @Published var customGridRows: Int = 4
    @Published var hapticEnabled: Bool = true
    @Published var defaultAspectRatio: AspectRatio = .threeByTwo
    @Published var defaultGuide: GuideType = .ruleOfThirds

    private enum CodingKeys: String, CodingKey {
        case selectedLensFocalLength, selectedAspectRatio, selectedGuide
        case guideOrientation, overlayColorHex, overlayOpacity, overlayLineWeight
        case showPowerPoints, customGridColumns, customGridRows, hapticEnabled
        case defaultAspectRatio, defaultGuide
    }

    init() {}

    func save() {
        let encodable = UserSettingsCodable(
            selectedLensFocalLength: selectedLensFocalLength,
            selectedAspectRatio: selectedAspectRatio,
            selectedGuide: selectedGuide,
            guideOrientation: guideOrientation,
            overlayColorHex: overlayColorHex,
            overlayOpacity: overlayOpacity,
            overlayLineWeight: overlayLineWeight,
            showPowerPoints: showPowerPoints,
            customGridColumns: customGridColumns,
            customGridRows: customGridRows,
            hapticEnabled: hapticEnabled,
            defaultAspectRatio: defaultAspectRatio,
            defaultGuide: defaultGuide
        )
        if let data = try? JSONEncoder().encode(encodable) {
            UserDefaults.standard.set(data, forKey: "framecomp.settings")
        }
    }

    static func load() -> UserSettings {
        guard let data = UserDefaults.standard.data(forKey: "framecomp.settings"),
              let dec = try? JSONDecoder().decode(UserSettingsCodable.self, from: data)
        else { return UserSettings() }
        let s = UserSettings()
        s.selectedLensFocalLength = dec.selectedLensFocalLength
        s.selectedAspectRatio = dec.selectedAspectRatio
        s.selectedGuide = dec.selectedGuide
        s.guideOrientation = dec.guideOrientation
        s.overlayColorHex = dec.overlayColorHex
        s.overlayOpacity = dec.overlayOpacity
        s.overlayLineWeight = dec.overlayLineWeight
        s.showPowerPoints = dec.showPowerPoints
        s.customGridColumns = dec.customGridColumns
        s.customGridRows = dec.customGridRows
        s.hapticEnabled = dec.hapticEnabled
        s.defaultAspectRatio = dec.defaultAspectRatio
        s.defaultGuide = dec.defaultGuide
        return s
    }
}
