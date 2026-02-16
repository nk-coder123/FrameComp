//
//  SpiralOverlay.swift
//  FrameComp
//
//  Golden spiral using recursive golden rectangle subdivision
//  with quarter-circle Bezier arcs. 4 orientations.
//

import Foundation
import CoreGraphics

struct SpiralOverlay: CompositionOverlay {
    let id = "spiral"
    let displayName = "Golden Spiral"
    let sfSymbolName = "square.on.circle"
    let supportedOrientations = 4

    private let phi: CGFloat = 1.6180339887

    func path(in rect: CGRect, orientation: Int) -> CGPath {
        let path = CGMutablePath()
        let subdivisionPath = CGMutablePath()

        // Number of recursive subdivisions (8-10 gives a smooth spiral)
        let iterations = 9

        // Working rectangle that shrinks each iteration
        var currentRect = rect

        // Starting direction depends on orientation.
        // Direction determines which side the square is cut from:
        // 0 = right, 1 = bottom, 2 = left, 3 = top
        var direction = orientation % 4

        for _ in 0..<iterations {
            let w = currentRect.width
            let h = currentRect.height

            // Determine square size (from the short side)
            let squareSize: CGFloat
            let squareRect: CGRect
            let nextRect: CGRect

            switch direction % 4 {
            case 0: // Cut square from the RIGHT side
                squareSize = h
                squareRect = CGRect(
                    x: currentRect.maxX - squareSize,
                    y: currentRect.minY,
                    width: squareSize,
                    height: squareSize
                )
                nextRect = CGRect(
                    x: currentRect.minX,
                    y: currentRect.minY,
                    width: w - squareSize,
                    height: h
                )
                // Quarter arc: from bottom-right of square to top-left area
                addArc(to: path, in: squareRect, quadrant: direction % 4)

            case 1: // Cut square from the BOTTOM
                squareSize = w
                squareRect = CGRect(
                    x: currentRect.minX,
                    y: currentRect.maxY - squareSize,
                    width: squareSize,
                    height: squareSize
                )
                nextRect = CGRect(
                    x: currentRect.minX,
                    y: currentRect.minY,
                    width: w,
                    height: h - squareSize
                )
                addArc(to: path, in: squareRect, quadrant: direction % 4)

            case 2: // Cut square from the LEFT
                squareSize = h
                squareRect = CGRect(
                    x: currentRect.minX,
                    y: currentRect.minY,
                    width: squareSize,
                    height: squareSize
                )
                nextRect = CGRect(
                    x: currentRect.minX + squareSize,
                    y: currentRect.minY,
                    width: w - squareSize,
                    height: h
                )
                addArc(to: path, in: squareRect, quadrant: direction % 4)

            default: // 3 — Cut square from the TOP
                squareSize = w
                squareRect = CGRect(
                    x: currentRect.minX,
                    y: currentRect.minY,
                    width: squareSize,
                    height: squareSize
                )
                nextRect = CGRect(
                    x: currentRect.minX,
                    y: currentRect.minY + squareSize,
                    width: w,
                    height: h - squareSize
                )
                addArc(to: path, in: squareRect, quadrant: direction % 4)
            }

            // Draw faint subdivision line (add to subdivision path)
            subdivisionPath.addRect(squareRect)

            // Move to the remaining (smaller) rectangle
            currentRect = nextRect

            // Rotate direction for next iteration
            direction = (direction + 1) % 4

            // Safety: stop if rectangle becomes degenerate
            if currentRect.width < 1 || currentRect.height < 1 { break }
        }

        // Add subdivision rectangles to the main path with thinner appearance
        // (The view model can render these separately if desired,
        //  but for simplicity we add them to the same path)
        path.addPath(subdivisionPath)

        return path
    }

    /// Draw a quarter-circle arc inside a square.
    /// The quadrant determines which corner is the center of the arc
    /// and which direction it sweeps.
    private func addArc(to path: CGMutablePath, in square: CGRect, quadrant: Int) {
        let s = square.width // square side length
        let cx: CGFloat
        let cy: CGFloat
        let startAngle: CGFloat
        let endAngle: CGFloat

        switch quadrant {
        case 0: // Cut from right — center at top-left of square, sweep from bottom to right
            cx = square.minX
            cy = square.minY
            startAngle = .pi / 2    // pointing down (6 o'clock)
            endAngle = 0            // pointing right (3 o'clock)
        case 1: // Cut from bottom — center at top-right, sweep from left to bottom
            cx = square.maxX
            cy = square.minY
            startAngle = .pi        // pointing left (9 o'clock)
            endAngle = .pi / 2      // pointing down (6 o'clock)
        case 2: // Cut from left — center at bottom-right, sweep from top to left
            cx = square.maxX
            cy = square.maxY
            startAngle = 3 * .pi / 2 // pointing up (12 o'clock)
            endAngle = .pi            // pointing left (9 o'clock)
        default: // 3 — Cut from top — center at bottom-left, sweep from right to top
            cx = square.minX
            cy = square.maxY
            startAngle = 0              // pointing right (3 o'clock)
            endAngle = 3 * .pi / 2     // pointing up (12 o'clock)
        }

        path.addArc(
            center: CGPoint(x: cx, y: cy),
            radius: s,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
    }

    func accentPoints(in rect: CGRect, orientation: Int) -> [CGPoint] {
        // Convergence point — approximate the spiral's focal point
        // Located at approximately phi ratio from each edge
        let fx = rect.width / (phi + 1)
        let fy = rect.height / (phi + 1)

        switch orientation % 4 {
        case 0: return [CGPoint(x: rect.minX + fx, y: rect.minY + fy)]
        case 1: return [CGPoint(x: rect.maxX - fx, y: rect.minY + fy)]
        case 2: return [CGPoint(x: rect.maxX - fx, y: rect.maxY - fy)]
        default: return [CGPoint(x: rect.minX + fx, y: rect.maxY - fy)]
        }
    }
}
