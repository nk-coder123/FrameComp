//
//  ZoomMapper.swift
//  FrameComp
//
//  Maps Fuji lens focal length → iPhone camera + zoom factor.
//

import Foundation
import AVFoundation
import CoreGraphics

struct ZoomMapper {
    struct CameraModule {
        let device: AVCaptureDevice
        let nativeEquivMM: CGFloat
    }

    let availableModules: [CameraModule]

    struct MappingResult {
        let device: AVCaptureDevice
        let zoomFactor: CGFloat
        let isApproximate: Bool
        let isWiderThanDevice: Bool
    }

    init(availableModules: [DeviceCapabilityDetector.CameraModuleInfo]) {
        self.availableModules = availableModules.map {
            CameraModule(device: $0.device, nativeEquivMM: $0.nativeEquivMM)
        }
    }

    func map(fujiFocalMM: CGFloat) -> MappingResult {
        let targetEquiv = fujiFocalMM * SensorSpec.cropFactor
        guard let firstModule = availableModules.first else {
            fatalError("No camera modules available")
        }
        let best = availableModules
            .filter { $0.nativeEquivMM <= targetEquiv }
            .max(by: { $0.nativeEquivMM < $1.nativeEquivMM })
            ?? availableModules.min(by: { $0.nativeEquivMM < $1.nativeEquivMM }) ?? firstModule
        let zoom = targetEquiv / best.nativeEquivMM
        let maxZoom = best.device.activeFormat.videoMaxZoomFactor
        let clampedZoom = min(max(1.0, zoom), maxZoom)
        let isWiderThanDevice = targetEquiv < best.nativeEquivMM
        return MappingResult(
            device: best.device,
            zoomFactor: clampedZoom,
            isApproximate: zoom > maxZoom,
            isWiderThanDevice: isWiderThanDevice
        )
    }
}
