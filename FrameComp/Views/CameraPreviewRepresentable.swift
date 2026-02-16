//
//  CameraPreviewRepresentable.swift
//  FrameComp
//
//  UIViewRepresentable wrapping AVCaptureVideoPreviewLayer.
//

import SwiftUI
import AVFoundation

struct CameraPreviewRepresentable: UIViewRepresentable {
    let session: AVCaptureSession
    @ObservedObject var viewModel: ViewfinderViewModel

    func makeUIView(context: Context) -> CameraPreviewUIView {
        let view = CameraPreviewUIView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        view.onLayout = { [weak view, weak viewModel] in
            guard let v = view, let vm = viewModel else { return }
            vm.updateOverlay(on: v)
        }
        return view
    }

    func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {
        viewModel.updateOverlay(on: uiView)
    }
}

class CameraPreviewUIView: UIView {
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    var overlayLayer: CAShapeLayer?
    var accentLayer: CAShapeLayer?
    var maskOverlayLayer: CAShapeLayer?
    var onLayout: (() -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()
        onLayout?()
    }
}
