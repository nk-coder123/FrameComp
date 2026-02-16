//
//  CameraEngine.swift
//  FrameComp
//
//  AVCaptureSession owner, device switching, zoom control.
//

import Foundation
import AVFoundation
import Combine

final class CameraEngine: ObservableObject {
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.framecomp.camera")
    private var currentDevice: AVCaptureDevice?
    private var currentInput: AVCaptureDeviceInput?
    @Published var isRunning = false
    @Published var isApproximateFOV = false
    @Published var isWiderThanDevice = false
    private let detector = DeviceCapabilityDetector()
    private lazy var zoomMapper = ZoomMapper(availableModules: detector.modules)

    func start() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo
            if let main = self.detector.mainCamera {
                self.switchToDevice(main)
            }
            self.session.commitConfiguration()
            self.session.startRunning()
            DispatchQueue.main.async { self.isRunning = true }
        }
    }

    func applyLens(focalLengthMM: CGFloat) {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            let result = self.zoomMapper.map(fujiFocalMM: focalLengthMM)
            if result.device != self.currentDevice {
                self.session.beginConfiguration()
                self.switchToDevice(result.device)
                self.session.commitConfiguration()
            }
            do {
                try result.device.lockForConfiguration()
                result.device.ramp(toVideoZoomFactor: result.zoomFactor, withRate: 8.0)
                result.device.unlockForConfiguration()
                DispatchQueue.main.async {
                    self.isApproximateFOV = result.isApproximate
                    self.isWiderThanDevice = result.isWiderThanDevice
                }
            } catch {
                DispatchQueue.main.async {
                    self.isApproximateFOV = true
                    self.isWiderThanDevice = false
                }
            }
        }
    }

    private func switchToDevice(_ device: AVCaptureDevice) {
        if let currentInput { session.removeInput(currentInput) }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        if session.canAddInput(input) {
            session.addInput(input)
            currentInput = input
            currentDevice = device
        }
    }

    func stop() {
        sessionQueue.async { [weak self] in
            self?.session.stopRunning()
            DispatchQueue.main.async { self?.isRunning = false }
        }
    }
}
