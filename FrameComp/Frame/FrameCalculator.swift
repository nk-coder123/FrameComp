//
//  FrameCalculator.swift
//  FrameComp
//
//  Aspect ratio → CGRect within preview bounds.
//

import Foundation
import CoreGraphics

struct FrameCalculator {
    /// Calculate the largest rect of the given aspect ratio
    /// that fits centered within the preview bounds.
    static func activeFrame(
        in previewBounds: CGRect,
        aspectRatio: AspectRatio
    ) -> CGRect {
        let targetRatio = aspectRatio.widthRatio / aspectRatio.heightRatio
        let boundsRatio = previewBounds.width / previewBounds.height
        let frameWidth: CGFloat
        let frameHeight: CGFloat
        if boundsRatio > targetRatio {
            frameHeight = previewBounds.height
            frameWidth = frameHeight * targetRatio
        } else {
            frameWidth = previewBounds.width
            frameHeight = frameWidth / targetRatio
        }
        let x = previewBounds.midX - frameWidth / 2.0
        let y = previewBounds.midY - frameHeight / 2.0
        return CGRect(x: x, y: y, width: frameWidth, height: frameHeight)
    }
}
