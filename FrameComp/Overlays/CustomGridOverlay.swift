//
//  CustomGridOverlay.swift
//  FrameComp
//
//  User-configurable N×M grid (2–24 cols/rows).
//

import Foundation
import CoreGraphics

struct CustomGridOverlay: CompositionOverlay {
    let id = "customGrid"
    let displayName = "Custom Grid"
    let sfSymbolName = "rectangle.grid.3x2"
    let supportedOrientations = 1

    var columns: Int = 6
    var rows: Int = 4

    func path(in rect: CGRect, orientation: Int) -> CGPath {
        let path = CGMutablePath()
        let cols = max(2, min(24, columns))
        let rws = max(2, min(24, rows))
        let colW = rect.width / CGFloat(cols)
        let rowH = rect.height / CGFloat(rws)
        for i in 1..<cols {
            let x = rect.minX + colW * CGFloat(i)
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: x, y: rect.maxY))
        }
        for i in 1..<rws {
            let y = rect.minY + rowH * CGFloat(i)
            path.move(to: CGPoint(x: rect.minX, y: y))
            path.addLine(to: CGPoint(x: rect.maxX, y: y))
        }
        return path
    }
}
