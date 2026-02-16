//
//  TwoFingerOpacityGestureView.swift
//  FrameComp
//
//  Two-finger vertical swipe to adjust overlay opacity (20%–100%).
//

import SwiftUI
import UIKit

struct TwoFingerOpacityGestureView: UIViewRepresentable {
    @ObservedObject var viewModel: ViewfinderViewModel

    func makeUIView(context: Context) -> TwoFingerOpacityUIView {
        let view = TwoFingerOpacityUIView()
        view.onVerticalSwipe = { delta in
            viewModel.adjustOverlayOpacity(by: delta)
        }
        return view
    }

    func updateUIView(_ uiView: TwoFingerOpacityUIView, context: Context) {}
}

class TwoFingerOpacityUIView: UIView {
    var onVerticalSwipe: ((CGFloat) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGesture()
    }

    private func setupGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.minimumNumberOfTouches = 2
        pan.maximumNumberOfTouches = 2
        addGestureRecognizer(pan)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let sensitivity: CGFloat = 0.002
        let delta = -translation.y * sensitivity
        if abs(delta) > 0.001 {
            onVerticalSwipe?(delta)
        }
        gesture.setTranslation(.zero, in: self)
    }
}
