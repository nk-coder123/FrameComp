//
//  FOVMatcher.swift
//  FrameComp
//
//  Pure math: focal length → FOV → zoom factor.
//

import Foundation
import CoreGraphics

struct FOVMatcher {
    /// Calculate horizontal field of view for a Fuji X-mount lens
    static func horizontalFOV(focalLengthMM: CGFloat) -> CGFloat {
        let equivFocalLength = focalLengthMM * SensorSpec.cropFactor
        let fovRadians = 2.0 * atan(36.0 / (2.0 * equivFocalLength))
        return fovRadians * 180.0 / .pi
    }

    /// Calculate the 35mm equivalent focal length
    static func equivalentFocalLength(fujiFocalMM: CGFloat) -> CGFloat {
        return fujiFocalMM * SensorSpec.cropFactor
    }

    /// Calculate required iPhone zoom factor to match a Fuji lens FOV
    static func zoomFactor(
        fujiFocalMM: CGFloat,
        iPhoneNativeEquivMM: CGFloat
    ) -> CGFloat {
        let targetEquiv = fujiFocalMM * SensorSpec.cropFactor
        return targetEquiv / iPhoneNativeEquivMM
    }
}
