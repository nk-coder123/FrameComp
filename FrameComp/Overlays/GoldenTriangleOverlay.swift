//
//  GoldenTriangleOverlay.swift
//  FrameComp
//
//  Diagonal + golden-ratio divisions. 2 orientations.
//

import Foundation
import CoreGraphics

struct GoldenTriangleOverlay: CompositionOverlay {
    let id = "goldenTriangle"
    let displayName = "Golden Triangle"
    let sfSymbolName = "triangle.lefthalf.filled"
    let supportedOrientations = 2

    private let phi: CGFloat = 1.618
    private var goldenLow: CGFloat { 1.0 - 1.0 / phi }
    private var goldenHigh: CGFloat { 1.0 / phi }

    func path(in rect: CGRect, orientation: Int) -> CGPath {
        let path = CGMutablePath()
        if orientation % 2 == 0 {
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            let d = hypot(rect.width, rect.height)
            let lowX = rect.minX + (rect.maxX - rect.minX) * goldenLow
            let lowY = rect.maxY - (rect.maxY - rect.minY) * goldenLow
            let highX = rect.minX + (rect.maxX - rect.minX) * goldenHigh
            let highY = rect.maxY - (rect.maxY - rect.minY) * goldenHigh
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: lowX, y: lowY))
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: highX, y: highY))
        } else {
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            let lowX = rect.minX + (rect.maxX - rect.minX) * goldenHigh
            let lowY = rect.minY + (rect.maxY - rect.minY) * goldenHigh
            let highX = rect.minX + (rect.maxX - rect.minX) * goldenLow
            let highY = rect.minY + (rect.maxY - rect.minY) * goldenLow
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: lowX, y: lowY))
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: highX, y: highY))
        }
        return path
    }
}
