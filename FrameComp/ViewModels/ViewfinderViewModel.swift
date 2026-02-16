//
//  ViewfinderViewModel.swift
//  FrameComp
//
//  Bridges CameraEngine, FrameCalculator, overlays.
//

import Foundation
import UIKit
import Combine
import QuartzCore

final class ViewfinderViewModel: ObservableObject {
    let cameraEngine: CameraEngine
    private let settings: UserSettings

    @Published var selectedRatio: AspectRatio
    @Published var selectedGuide: GuideType
    @Published var guideOrientation: Int
    @Published var isOverlayVisible: Bool = true
    @Published var overlayOpacity: CGFloat = 0.6

    var animateNextGuideSwitch = false
    var animateNextRatioChange = false

    var currentGuide: GuideType { selectedGuide }
    var currentOrientation: Int { guideOrientation }

    init(cameraEngine: CameraEngine, settings: UserSettings) {
        self.cameraEngine = cameraEngine
        self.settings = settings
        self.selectedRatio = settings.selectedAspectRatio
        self.selectedGuide = settings.selectedGuide
        self.guideOrientation = settings.guideOrientation
        self.overlayOpacity = settings.overlayOpacity
    }

    func syncFromSettings() {
        selectedRatio = settings.selectedAspectRatio
        selectedGuide = settings.selectedGuide
        guideOrientation = settings.guideOrientation
        overlayOpacity = settings.overlayOpacity
    }

    func cycleAspectRatio() {
        let cases = AspectRatio.allCases
        guard let idx = cases.firstIndex(of: selectedRatio) else { return }
        let next = cases[(idx + 1) % cases.count]
        selectedRatio = next
        settings.selectedAspectRatio = next
        settings.save()
        animateNextRatioChange = true
    }

    func selectGuide(_ guide: GuideType) {
        selectedGuide = guide
        guideOrientation = 0
        settings.selectedGuide = guide
        settings.guideOrientation = 0
        settings.save()
        animateNextGuideSwitch = true
        if settings.hapticEnabled {
            let gen = UIImpactFeedbackGenerator(style: .light)
            gen.impactOccurred()
        }
    }

    func cycleGuideOrientation() {
        let overlay = getOverlay()
        guideOrientation = (guideOrientation + 1) % max(1, overlay.supportedOrientations)
        settings.guideOrientation = guideOrientation
        settings.save()
        if settings.hapticEnabled {
            let gen = UIImpactFeedbackGenerator(style: .light)
            gen.impactOccurred()
        }
    }

    func toggleOverlayVisibility() {
        isOverlayVisible.toggle()
    }

    /// Adjust overlay opacity by delta. Clamped to 0.2–1.0 range.
    func adjustOverlayOpacity(by delta: CGFloat) {
        overlayOpacity = min(1.0, max(0.2, overlayOpacity + delta))
        settings.overlayOpacity = overlayOpacity
        settings.save()
    }

    private func getOverlay() -> CompositionOverlay {
        if selectedGuide == .customGrid {
            var g = CustomGridOverlay()
            g.columns = settings.customGridColumns
            g.rows = settings.customGridRows
            return g
        }
        return selectedGuide.overlay
    }

    func updateOverlay(on previewView: CameraPreviewUIView) {
        let bounds = previewView.bounds
        let frameRect = FrameCalculator.activeFrame(in: bounds, aspectRatio: selectedRatio)

        if previewView.maskOverlayLayer == nil {
            let mask = CAShapeLayer()
            mask.fillRule = .evenOdd
            previewView.layer.addSublayer(mask)
            previewView.maskOverlayLayer = mask
        }
        if previewView.overlayLayer == nil {
            let overlay = CAShapeLayer()
            overlay.fillColor = nil
            overlay.strokeColor = UIColor.white.cgColor
            previewView.layer.addSublayer(overlay)
            previewView.overlayLayer = overlay
        }
        if previewView.accentLayer == nil {
            let accent = CAShapeLayer()
            accent.fillColor = UIColor.white.cgColor
            accent.strokeColor = nil
            previewView.layer.addSublayer(accent)
            previewView.accentLayer = accent
        }

        previewView.maskOverlayLayer?.frame = bounds
        previewView.overlayLayer?.frame = bounds
        previewView.accentLayer?.frame = bounds

        let maskPath = CGMutablePath()
        maskPath.addRect(bounds)
        maskPath.addRect(frameRect)
        previewView.maskOverlayLayer?.path = maskPath
        previewView.maskOverlayLayer?.fillRule = .evenOdd
        previewView.maskOverlayLayer?.fillColor = UIColor.black.withAlphaComponent(0.4).cgColor

        let overlay = getOverlay()
        let color = colorFromHex(settings.overlayColorHex)

        var effectiveOpacity = overlayOpacity
        if selectedGuide == .customGrid {
            let cols = settings.customGridColumns
            let rows = settings.customGridRows
            let cells = cols * rows
            if cells > 64 {
                let scale = CGFloat(cells - 64) / CGFloat(576 - 64)
                effectiveOpacity = overlayOpacity * (1.0 - scale * 0.6)
            }
        }

        let animate = animateNextGuideSwitch || animateNextRatioChange
        let duration: CFTimeInterval = animateNextGuideSwitch ? 0.15 : (animateNextRatioChange ? 0.2 : 0)
        if animate {
            CATransaction.begin()
            CATransaction.setAnimationDuration(duration)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        }

        previewView.overlayLayer?.path = overlay.path(in: frameRect, orientation: guideOrientation)
        previewView.overlayLayer?.strokeColor = color.cgColor
        previewView.overlayLayer?.opacity = Float(effectiveOpacity)
        previewView.overlayLayer?.lineWidth = settings.overlayLineWeight
        previewView.overlayLayer?.lineDashPattern = (selectedGuide == .symmetry) ? [6, 4] : nil

        if settings.showPowerPoints {
            let accentPath = CGMutablePath()
            for point in overlay.accentPoints(in: frameRect, orientation: guideOrientation) {
                accentPath.addEllipse(in: CGRect(x: point.x - 4, y: point.y - 4, width: 8, height: 8))
            }
            previewView.accentLayer?.path = accentPath
            previewView.accentLayer?.fillColor = color.cgColor
            previewView.accentLayer?.opacity = Float(effectiveOpacity)
        }

        if animate {
            CATransaction.commit()
            animateNextGuideSwitch = false
            animateNextRatioChange = false
        }
        previewView.accentLayer?.isHidden = !settings.showPowerPoints || !isOverlayVisible
        previewView.overlayLayer?.isHidden = !isOverlayVisible
    }

    private func colorFromHex(_ hex: String) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
