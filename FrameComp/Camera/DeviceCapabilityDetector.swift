//
//  DeviceCapabilityDetector.swift
//  FrameComp
//
//  Queries available iPhone camera modules and native focal lengths.
//

import Foundation
import AVFoundation
import CoreGraphics

final class DeviceCapabilityDetector {
    private let discoverySession = AVCaptureDevice.DiscoverySession(
        deviceTypes: [.builtInWideAngleCamera, .builtInUltraWideCamera, .builtInTelephotoCamera],
        mediaType: .video,
        position: .unspecified
    )

    struct CameraModuleInfo {
        let device: AVCaptureDevice
        let nativeEquivMM: CGFloat
    }

    private(set) lazy var modules: [CameraModuleInfo] = discoverModules()

    var mainCamera: AVCaptureDevice? {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    }

    private func discoverModules() -> [CameraModuleInfo] {
        var result: [CameraModuleInfo] = []
        for device in discoverySession.devices {
            guard device.position == .back else { continue }
            let equiv: CGFloat
            switch device.deviceType {
            case .builtInUltraWideCamera:
                equiv = 13.0
            case .builtInWideAngleCamera:
                equiv = 26.0
            case .builtInTelephotoCamera:
                equiv = 77.0
            default:
                equiv = 26.0
            }
            result.append(CameraModuleInfo(device: device, nativeEquivMM: equiv))
        }
        return result.sorted { $0.nativeEquivMM < $1.nativeEquivMM }
    }
}
