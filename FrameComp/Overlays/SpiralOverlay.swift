//
//  SpiralOverlay.swift
//  FrameComp
//
//  Fibonacci golden spiral — Bezier curve, 4 orientations.
//

import Foundation
import CoreGraphics

struct SpiralOverlay: CompositionOverlay {
    let id = "spiral"
    let displayName = "Golden Spiral"
    let sfSymbolName = "square.on.circle"
    let supportedOrientations = 4

    private let phi: CGFloat = 1.618

    func path(in rect: CGRect, orientation: Int) -> CGPath {
        let path = CGMutablePath()
        let w = rect.width
        let h = rect.height
        let segments = 64
        let ox: CGFloat
        let oy: CGFloat
        let signX: CGFloat
        let signY: CGFloat
        switch orientation % 4 {
        case 0: ox = rect.maxX; oy = rect.maxY; signX = -1; signY = -1
        case 1: ox = rect.minX; oy = rect.maxY; signX = 1; signY = -1
        case 2: ox = rect.minX; oy = rect.minY; signX = 1; signY = 1
        default: ox = rect.maxX; oy = rect.minY; signX = -1; signY = 1
        }
        var angle: CGFloat = 0
        var radius: CGFloat = 0.01
        var first = true
        for i in 0..<segments {
            let r = radius * min(w, h) * 0.5
            let x = ox + signX * cos(angle) * r
            let y = oy + signY * sin(angle) * r
            let pt = CGPoint(x: x, y: y)
            if first {
                path.move(to: pt)
                first = false
            } else {
                path.addLine(to: pt)
            }
            angle += .pi / 2.0 / CGFloat(segments / 4)
            radius *= pow(phi, .pi / 2.0 / CGFloat(segments / 4))
        }
        return path
    }

    func accentPoints(in rect: CGRect, orientation: Int) -> [CGPoint] {
        let w = rect.width
        let h = rect.height
        let margin = min(w, h) * 0.08
        switch orientation % 4 {
        case 0: return [CGPoint(x: rect.maxX - margin, y: rect.maxY - margin)]
        case 1: return [CGPoint(x: rect.minX + margin, y: rect.maxY - margin)]
        case 2: return [CGPoint(x: rect.minX + margin, y: rect.minY + margin)]
        default: return [CGPoint(x: rect.maxX - margin, y: rect.minY + margin)]
        }
    }
}
