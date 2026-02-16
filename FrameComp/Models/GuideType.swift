//
//  GuideType.swift
//  FrameComp
//
//  All composition guide types + overlay factory.
//

import Foundation

enum GuideType: String, Codable, CaseIterable {
    case ruleOfThirds
    case phiGrid
    case goldenSpiral
    case diagonal
    case triangle
    case dynamicSymmetry
    case center
    case symmetry
    case customGrid
    case goldenTriangle

    var overlay: CompositionOverlay {
        switch self {
        case .ruleOfThirds: return ThirdsOverlay()
        case .phiGrid: return PhiGridOverlay()
        case .goldenSpiral: return SpiralOverlay()
        case .diagonal: return DiagonalOverlay()
        case .triangle: return TriangleOverlay()
        case .dynamicSymmetry: return DynamicSymmetryOverlay()
        case .center: return CenterOverlay()
        case .symmetry: return SymmetryOverlay()
        case .customGrid: return CustomGridOverlay()
        case .goldenTriangle: return GoldenTriangleOverlay()
        }
    }
}
