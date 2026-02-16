//
//  DynamicSymmetryOverlay.swift
//  FrameComp
//
//  Jay Hambidge root rectangles — Baroque/Sinister/Combined.
//

import Foundation
import CoreGraphics

struct DynamicSymmetryOverlay: CompositionOverlay {
    let id = "dynamicSymmetry"
    let displayName = "Dynamic Symmetry"
    let sfSymbolName = "arrow.up.and.down.and.arrow.left.and.right"
    let supportedOrientations = 3

    func path(in rect: CGRect, orientation: Int) -> CGPath {
        let path = CGMutablePath()
        let w = rect.width
        let h = rect.height
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY
        let midX = rect.midX
        let midY = rect.midY

        switch orientation % 3 {
        case 0:
            path.move(to: CGPoint(x: minX, y: minY))
            path.addLine(to: CGPoint(x: maxX, y: maxY))
            path.move(to: CGPoint(x: minX, y: maxY))
            path.addLine(to: CGPoint(x: maxX, y: minY))
            path.move(to: CGPoint(x: midX, y: minY))
            path.addLine(to: CGPoint(x: maxX, y: midY))
            path.move(to: CGPoint(x: midX, y: maxY))
            path.addLine(to: CGPoint(x: minX, y: midY))
        case 1:
            path.move(to: CGPoint(x: minX, y: minY))
            path.addLine(to: CGPoint(x: maxX, y: maxY))
            path.move(to: CGPoint(x: minX, y: maxY))
            path.addLine(to: CGPoint(x: maxX, y: minY))
            path.move(to: CGPoint(x: minX, y: midY))
            path.addLine(to: CGPoint(x: midX, y: maxY))
            path.move(to: CGPoint(x: maxX, y: midY))
            path.addLine(to: CGPoint(x: midX, y: minY))
        default:
            path.move(to: CGPoint(x: minX, y: minY))
            path.addLine(to: CGPoint(x: maxX, y: maxY))
            path.move(to: CGPoint(x: minX, y: maxY))
            path.addLine(to: CGPoint(x: maxX, y: minY))
            path.move(to: CGPoint(x: midX, y: minY))
            path.addLine(to: CGPoint(x: maxX, y: midY))
            path.move(to: CGPoint(x: midX, y: maxY))
            path.addLine(to: CGPoint(x: minX, y: midY))
            path.move(to: CGPoint(x: minX, y: midY))
            path.addLine(to: CGPoint(x: midX, y: maxY))
            path.move(to: CGPoint(x: maxX, y: midY))
            path.addLine(to: CGPoint(x: midX, y: minY))
        }
        return path
    }
}
