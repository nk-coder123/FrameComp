//
//  TriangleOverlay.swift
//  FrameComp
//
//  Diagonal + perpendiculars from corners. 2 orientations.
//

import Foundation
import CoreGraphics

struct TriangleOverlay: CompositionOverlay {
    let id = "triangle"
    let displayName = "Triangle"
    let sfSymbolName = "triangle"
    let supportedOrientations = 2

    func path(in rect: CGRect, orientation: Int) -> CGPath {
        let path = CGMutablePath()
        if orientation % 2 == 0 {
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            let foot1 = footOfPerpendicular(from: CGPoint(x: rect.minX, y: rect.minY), to: CGPoint(x: rect.minX, y: rect.maxY), to: CGPoint(x: rect.maxX, y: rect.minY))
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: foot1)
            let foot2 = footOfPerpendicular(from: CGPoint(x: rect.maxX, y: rect.maxY), to: CGPoint(x: rect.minX, y: rect.maxY), to: CGPoint(x: rect.maxX, y: rect.minY))
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: foot2)
        } else {
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            let foot1 = footOfPerpendicular(from: CGPoint(x: rect.maxX, y: rect.minY), to: CGPoint(x: rect.maxX, y: rect.maxY), to: CGPoint(x: rect.minX, y: rect.minY))
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: foot1)
            let foot2 = footOfPerpendicular(from: CGPoint(x: rect.minX, y: rect.maxY), to: CGPoint(x: rect.maxX, y: rect.maxY), to: CGPoint(x: rect.minX, y: rect.minY))
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: foot2)
        }
        return path
    }

    private func footOfPerpendicular(from p: CGPoint, to a: CGPoint, to b: CGPoint) -> CGPoint {
        let ax = a.x
        let ay = a.y
        let bx = b.x
        let by = b.y
        let t = ((p.x - ax) * (bx - ax) + (p.y - ay) * (by - ay)) / ((bx - ax) * (bx - ax) + (by - ay) * (by - ay))
        let tClamped = max(0, min(1, t))
        return CGPoint(x: ax + tClamped * (bx - ax), y: ay + tClamped * (by - ay))
    }
}
