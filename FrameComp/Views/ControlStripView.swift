//
//  ControlStripView.swift
//  FrameComp
//
//  Bottom composition guide selector bar.
//

import SwiftUI

struct ControlStripView: View {
    @ObservedObject var viewModel: ViewfinderViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(GuideType.allCases, id: \.self) { guide in
                    let overlay = guide.overlay
                    Button {
                        if guide == viewModel.selectedGuide, overlay.supportedOrientations > 1 {
                            viewModel.cycleGuideOrientation()
                        } else {
                            viewModel.selectGuide(guide)
                        }
                    } label: {
                        Image(systemName: overlay.sfSymbolName)
                            .font(.system(size: 22))
                            .foregroundColor(guide == viewModel.selectedGuide ? .yellow : .white)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 56)
        .background(.ultraThinMaterial)
    }
}
