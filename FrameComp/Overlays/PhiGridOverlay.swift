//
//  PhiGridOverlay.swift
//  FrameComp
//
//  Golden Ratio grid — 38.2% / 61.8% divisions.
//

import Foundation
import CoreGraphics

struct PhiGridOverlay: CompositionOverlay {
    let id = "phiGrid"
    let displayName = "Phi Grid"
    let sfSymbolName = "rectangle.3.group"
    let supportedOrientations = 1

    private let phi: CGFloat = 1.0 / 1.618  // ≈ 0.618

    func path(in rect: CGRect, orientation: Int) -> CGPath {
        let path = CGMutablePath()
        let x1 = rect.minX + rect.width * (1.0 - phi)
        let x2 = rect.minX + rect.width * phi
        let y1 = rect.minY + rect.height * (1.0 - phi)
        let y2 = rect.minY + rect.height * phi
        path.move(to: CGPoint(x: x1, y: rect.minY))
        path.addLine(to: CGPoint(x: x1, y: rect.maxY))
        path.move(to: CGPoint(x: x2, y: rect.minY))
        path.addLine(to: CGPoint(x: x2, y: rect.maxY))
        path.move(to: CGPoint(x: rect.minX, y: y1))
        path.addLine(to: CGPoint(x: rect.maxX, y: y1))
        path.move(to: CGPoint(x: rect.minX, y: y2))
        path.addLine(to: CGPoint(x: rect.maxX, y: y2))
        return path
    }

    func accentPoints(in rect: CGRect, orientation: Int) -> [CGPoint] {
        let x1 = rect.minX + rect.width * (1.0 - phi)
        let x2 = rect.minX + rect.width * phi
        let y1 = rect.minY + rect.height * (1.0 - phi)
        let y2 = rect.minY + rect.height * phi
        return [
            CGPoint(x: x1, y: y1),
            CGPoint(x: x2, y: y1),
            CGPoint(x: x1, y: y2),
            CGPoint(x: x2, y: y2),
        ]
    }
}
