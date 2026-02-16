//
//  ViewfinderView.swift
//  FrameComp
//
//  Root view composing camera preview, overlays, and controls.
//

import SwiftUI
import AVFoundation

struct ViewfinderView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var cameraEngine = CameraEngine()
    @StateObject private var settings = UserSettings.load()
    @StateObject private var settingsVM: SettingsViewModel
    @StateObject private var viewModel: ViewfinderViewModel

    @State private var showLensPicker = false
    @State private var showSettings = false
    @State private var showChrome = true
    @State private var cameraPermissionDenied = false

    init() {
        let s = UserSettings.load()
        let ce = CameraEngine()
        let vm = ViewfinderViewModel(cameraEngine: ce, settings: s)
        _settings = StateObject(wrappedValue: s)
        _cameraEngine = StateObject(wrappedValue: ce)
        _settingsVM = StateObject(wrappedValue: SettingsViewModel(settings: s))
        _viewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        ZStack {
            if cameraPermissionDenied {
                cameraDeniedView
            } else {
                cameraView
                if showChrome {
                    VStack {
                        topBar
                        Spacer()
                        ControlStripView(viewModel: viewModel)
                    }
                    fovBadge
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            checkCameraPermission()
            cameraEngine.start()
            cameraEngine.applyLens(focalLengthMM: settings.selectedLensFocalLength)
            viewModel.syncFromSettings()
        }
        .onChange(of: settings.selectedLensFocalLength) { _, newValue in
            cameraEngine.applyLens(focalLengthMM: newValue)
        }
        .onDisappear {
            cameraEngine.stop()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                cameraEngine.start()
                cameraEngine.applyLens(focalLengthMM: settings.selectedLensFocalLength)
            }
        }
        .sheet(isPresented: $showLensPicker) {
            LensPickerView(settings: settings)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(settings: settings)
                .onDisappear { viewModel.syncFromSettings() }
        }
    }

    private var cameraView: some View {
        GeometryReader { _ in
            CameraPreviewRepresentable(session: cameraEngine.session, viewModel: viewModel)
                .overlay(TwoFingerOpacityGestureView(viewModel: viewModel))
                .onTapGesture(count: 2) {
                    viewModel.toggleOverlayVisibility()
                }
                .onTapGesture(count: 1) {
                    let overlay = viewModel.currentGuide.overlay
                    if overlay.supportedOrientations > 1 {
                        viewModel.cycleGuideOrientation()
                    }
                }
                .onLongPressGesture(minimumDuration: 1) {
                    withAnimation { showChrome.toggle() }
                }
                .gesture(
                    MagnificationGesture()
                        .onEnded { _ in
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.warning)
                        }
                )
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            Spacer()
            Button {
                showLensPicker = true
            } label: {
                Text("\(Int(settings.selectedLensFocalLength))mm")
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .foregroundColor(.white)
            }
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.cycleAspectRatio()
                }
            } label: {
                Text(viewModel.selectedRatio.displayName)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .padding(.top, 8)
    }

    private var fovBadge: some View {
        Group {
            if cameraEngine.isWiderThanDevice {
                Text("FOV wider than device can display.")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            } else if cameraEngine.isApproximateFOV {
                Text("Approximate FOV")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 70)
    }

    private var cameraDeniedView: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.fill")
                .font(.system(size: 60))
            Text("Camera Access Required")
                .font(.title2)
            Text("FrameComp uses your camera to preview compositions matching your Fujifilm X-T5 sensor. No photos are captured or stored.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraPermissionDenied = false
        case .denied, .restricted:
            cameraPermissionDenied = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    cameraPermissionDenied = !granted
                }
            }
        @unknown default:
            cameraPermissionDenied = true
        }
    }
}

