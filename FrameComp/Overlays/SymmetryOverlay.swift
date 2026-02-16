//
//  SymmetryOverlay.swift
//  FrameComp
//
//  H/V/Both dashed center lines. Use lineDashPattern [6, 4] on CAShapeLayer.
//

import Foundation
import CoreGraphics

struct SymmetryOverlay: CompositionOverlay {
    let id = "symmetry"
    let displayName = "Symmetry"
    let sfSymbolName = "line.diagonal"
    let supportedOrientations = 3

    func path(in rect: CGRect, orientation: Int) -> CGPath {
        let path = CGMutablePath()
        let mx = rect.midX
        let my = rect.midY
        switch orientation % 3 {
        case 0:
            path.move(to: CGPoint(x: mx, y: rect.minY))
            path.addLine(to: CGPoint(x: mx, y: rect.maxY))
        case 1:
            path.move(to: CGPoint(x: rect.minX, y: my))
            path.addLine(to: CGPoint(x: rect.maxX, y: my))
        default:
            path.move(to: CGPoint(x: mx, y: rect.minY))
            path.addLine(to: CGPoint(x: mx, y: rect.maxY))
            path.move(to: CGPoint(x: rect.minX, y: my))
            path.addLine(to: CGPoint(x: rect.maxX, y: my))
        }
        return path
    }
}
