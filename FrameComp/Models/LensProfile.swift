//
//  LensProfile.swift
//  FrameComp
//
//  Fujinon X-mount lens presets.
//

import Foundation
import CoreGraphics

struct LensProfile: Identifiable, Codable {
    let id: String
    let displayName: String
    let focalLengthMM: CGFloat
    let category: LensCategory

    enum LensCategory: String, Codable, CaseIterable {
        case ultraWide
        case wide
        case standard
        case shortTele
        case telephoto
    }

    static let presets: [LensProfile] = [
        .init(id: "xf8", displayName: "XF 8mm f/3.5", focalLengthMM: 8, category: .ultraWide),
        .init(id: "xf14", displayName: "XF 14mm f/2.8", focalLengthMM: 14, category: .ultraWide),
        .init(id: "xf16", displayName: "XF 16mm f/1.4", focalLengthMM: 16, category: .wide),
        .init(id: "xf18", displayName: "XF 18mm f/1.4", focalLengthMM: 18, category: .wide),
        .init(id: "xf23", displayName: "XF 23mm f/1.4 / f/2", focalLengthMM: 23, category: .wide),
        .init(id: "xf27", displayName: "XF 27mm f/2.8", focalLengthMM: 27, category: .standard),
        .init(id: "xf33", displayName: "XF 33mm f/1.4", focalLengthMM: 33, category: .standard),
        .init(id: "xf35", displayName: "XF 35mm f/1.4 / f/2", focalLengthMM: 35, category: .standard),
        .init(id: "xf50", displayName: "XF 50mm f/1.0 / f/2", focalLengthMM: 50, category: .shortTele),
        .init(id: "xf56", displayName: "XF 56mm f/1.2", focalLengthMM: 56, category: .shortTele),
        .init(id: "xf90", displayName: "XF 90mm f/2", focalLengthMM: 90, category: .telephoto),
    ]
}
