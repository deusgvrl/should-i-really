//
//  UploadingView.swift
//  should-i-really
//
//  Created by Steffany Florence on 21/07/26.
//

import SwiftUI

struct UploadingView: View {
    var uploadDuration: Double = 2.0
    var onComplete: () -> Void
    
    @State private var progress: CGFloat = 0.0
    
    var backgroundImage: String = "background"
    var frameImage: String = "uploading_frame"
    var fillImage: String = "uploading_fill"
    
    var body: some View {
        ZStack() {
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Uploading...")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.textBrown)
                    .padding(.bottom, 8)
                
                CustomProgressBar(
                    progress: progress,
                    frameImageName: frameImage,
                    fillImageName: fillImage
                )
                .frame(width: 300, height: 38)
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await runProgressAnimation()
        }
    }
    
    private func runProgressAnimation() async {
        let totalSteps = 60
        let interval = uploadDuration / Double(totalSteps)
        
        for step in 1...totalSteps {
            try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            withAnimation(.linear(duration: interval)) {
                progress = CGFloat(step) / CGFloat(totalSteps)
            }
        }
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        onComplete()
    }
}

// MARK: - Custom Progress Bar

struct CustomProgressBar: View {
    var progress: CGFloat
    var frameImageName: String
    var fillImageName: String
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let totalHeight = geometry.size.height
            let currentWidth = totalWidth * max(0, min(progress, 1.0))
            
            ZStack {
                Image(frameImageName)
                    .resizable()
                    .frame(width: totalWidth, height: totalHeight)
                
                Image(fillImageName)
                    .resizable()
                    .frame(width: totalWidth - 8, height: totalHeight - 6)
                    .mask(
                        ZStack(alignment: .leading) {
                            Capsule()
                                .frame(width: currentWidth, height: totalHeight)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    )
            }
        }
    }
}
