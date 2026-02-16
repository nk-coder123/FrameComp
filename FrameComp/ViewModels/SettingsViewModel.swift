//
//  SettingsViewModel.swift
//  FrameComp
//
//  Bridges UserSettings to UI.
//

import Foundation
import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {
    let settings: UserSettings

    init(settings: UserSettings) {
        self.settings = settings
    }

    func save() {
        settings.save()
    }
}
