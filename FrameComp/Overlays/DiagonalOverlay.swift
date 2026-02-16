//
//  DiagonalOverlay.swift
//  FrameComp
//
//  Corner-to-corner X pattern.
//

import Foundation
import CoreGraphics

struct DiagonalOverlay: CompositionOverlay {
    let id = "diagonal"
    let displayName = "Diagonal"
    let sfSymbolName = "xmark"
    let supportedOrientations = 1

    func path(in rect: CGRect, orientation: Int) -> CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        return path
    }

    func accentPoints(in rect: CGRect, orientation: Int) -> [CGPoint] {
        [CGPoint(x: rect.midX, y: rect.midY)]
    }
}
