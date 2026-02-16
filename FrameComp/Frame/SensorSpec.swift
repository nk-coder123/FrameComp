//
//  SensorSpec.swift
//  FrameComp
//
//  X-T5 sensor constants — single source of truth for FOV math.
//

import Foundation
import CoreGraphics

struct SensorSpec {
    static let sensorWidthMM: CGFloat = 23.5
    static let sensorHeightMM: CGFloat = 15.6
    static let effectivePixelsX: Int = 7728
    static let effectivePixelsY: Int = 5152
    static let nativeAspectRatio: CGFloat = 3.0 / 2.0  // 1.5
    static let cropFactor: CGFloat = 1.5
    static let mountName: String = "Fujifilm X Mount"
}
