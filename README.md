# FrameComp

**Fujifilm X-T5 Composition Assistant** — Native iOS app for pre-visualizing compositions with your iPhone before shooting.

## Overview

FrameComp turns your iPhone into an X-T5 viewfinder. Select your Fujinon lens, and the app crops/zooms the camera feed to match the exact field of view your X-T5 will capture. Ten composition guides (Rule of Thirds, Phi Grid, Golden Spiral, etc.) overlay the live preview.

- **Offline-first** — No network, no accounts
- **Apple frameworks only** — AVFoundation, SwiftUI, UIKit, Combine
- **iOS 16.0+**

## Building

1. Open `FrameComp.xcodeproj` in Xcode
2. Select your development team in Signing & Capabilities
3. Build and run on a physical iPhone or simulator (Cmd+R)

## Project Structure

```
FrameComp/
├── App/           FrameCompApp.swift, Info.plist
├── Camera/        CameraEngine, FOVMatcher, ZoomMapper, DeviceCapabilityDetector
├── Frame/         FrameCalculator, SensorSpec
├── Overlays/      CompositionOverlay protocol + 10 guide implementations
├── Models/        AspectRatio, GuideType, LensProfile, UserSettings
├── ViewModels/    ViewfinderViewModel, SettingsViewModel
└── Views/         ViewfinderView, CameraPreview, ControlStrip, LensPicker, Settings
```

## Alternative: XcodeGen

If you have [XcodeGen](https://github.com/yonaskolb/XcodeGen) installed:

```bash
brew install xcodegen
xcodegen generate
open FrameComp.xcodeproj
```

## Specification

See `framecomp_spec.txt` for the full product specification.
