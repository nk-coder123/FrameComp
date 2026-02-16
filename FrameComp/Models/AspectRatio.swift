//
//  AspectRatio.swift
//  FrameComp
//
//  Fujifilm X-T5 aspect ratio modes.
//

import Foundation
import CoreGraphics

enum AspectRatio: String, Codable, CaseIterable {
    case threeByTwo
    case sixteenByNine
    case oneByOne

    var widthRatio: CGFloat {
        switch self {
        case .threeByTwo: return 3.0
        case .sixteenByNine: return 16.0
        case .oneByOne: return 1.0
        }
    }

    var heightRatio: CGFloat {
        switch self {
        case .threeByTwo: return 2.0
        case .sixteenByNine: return 9.0
        case .oneByOne: return 1.0
        }
    }

    var displayName: String {
        switch self {
        case .threeByTwo: return "3:2"
        case .sixteenByNine: return "16:9"
        case .oneByOne: return "1:1"
        }
    }
}
