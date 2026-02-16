//
//  CenterOverlay.swift
//  FrameComp
//
//  Center crosshair + circle.
//

import Foundation
import CoreGraphics

struct CenterOverlay: CompositionOverlay {
    let id = "center"
    let displayName = "Center"
    let sfSymbolName = "plus.circle"
    let supportedOrientations = 1

    func path(in rect: CGRect, orientation: Int) -> CGPath {
        let path = CGMutablePath()
        let mx = rect.midX
        let my = rect.midY
        path.move(to: CGPoint(x: mx, y: rect.minY))
        path.addLine(to: CGPoint(x: mx, y: rect.maxY))
        path.move(to: CGPoint(x: rect.minX, y: my))
        path.addLine(to: CGPoint(x: rect.maxX, y: my))
        let circleRadius = rect.width * 0.03
        path.addEllipse(in: CGRect(x: mx - circleRadius, y: my - circleRadius, width: circleRadius * 2, height: circleRadius * 2))
        return path
    }
}
