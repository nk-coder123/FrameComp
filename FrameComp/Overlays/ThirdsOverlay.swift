//
//  ThirdsOverlay.swift
//  FrameComp
//
//  Rule of Thirds — 3×3 grid with power points.
//

import Foundation
import CoreGraphics

struct ThirdsOverlay: CompositionOverlay {
    let id = "thirds"
    let displayName = "Rule of Thirds"
    let sfSymbolName = "grid"
    let supportedOrientations = 1

    func path(in rect: CGRect, orientation: Int) -> CGPath {
        let path = CGMutablePath()
        let thirdW = rect.width / 3.0
        let thirdH = rect.height / 3.0
        for i in 1...2 {
            let x = rect.minX + thirdW * CGFloat(i)
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: x, y: rect.maxY))
        }
        for i in 1...2 {
            let y = rect.minY + thirdH * CGFloat(i)
            path.move(to: CGPoint(x: rect.minX, y: y))
            path.addLine(to: CGPoint(x: rect.maxX, y: y))
        }
        return path
    }

    func accentPoints(in rect: CGRect, orientation: Int) -> [CGPoint] {
        let thirdW = rect.width / 3.0
        let thirdH = rect.height / 3.0
        return [
            CGPoint(x: rect.minX + thirdW, y: rect.minY + thirdH),
            CGPoint(x: rect.minX + thirdW * 2, y: rect.minY + thirdH),
            CGPoint(x: rect.minX + thirdW, y: rect.minY + thirdH * 2),
            CGPoint(x: rect.minX + thirdW * 2, y: rect.minY + thirdH * 2),
        ]
    }
}
