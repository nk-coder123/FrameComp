//
//  CompositionOverlay.swift
//  FrameComp
//
//  Protocol for all composition guide overlays.
//

import Foundation
import CoreGraphics

protocol CompositionOverlay {
    var id: String { get }
    var displayName: String { get }
    var sfSymbolName: String { get }
    var supportedOrientations: Int { get }

    /// Returns the primary line paths for the overlay
    func path(in rect: CGRect, orientation: Int) -> CGPath

    /// Returns accent/power points (intersections, focal points)
    func accentPoints(in rect: CGRect, orientation: Int) -> [CGPoint]
}

extension CompositionOverlay {
    func accentPoints(in rect: CGRect, orientation: Int) -> [CGPoint] { [] }
}
