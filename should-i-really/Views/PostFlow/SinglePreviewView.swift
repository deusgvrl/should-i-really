//
//  SinglePreviewView.swift
//  should-i-really
//
//  Created by Jose Putra Perdana Taneo on 22/07/26.
//

import SwiftUI

struct SinglePreviewView: View {
    let node: UserPost
    let size: CGFloat
    
    var body: some View {
        VStack {
            if node.nodeId == "first_post" || node.nodeId == "last_post" {
                Image(node.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .circular))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.textBrown, lineWidth: 1)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
            } else {
                QuadrantImageView(imageName: node.imageName, quadrant: node.selectedQuadrant, size: size)
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .circular))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.textBrown, lineWidth: 1)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.textBrown, lineWidth: 1)
        )
    }
}

//#Preview {
//    SinglePreviewView(imageName: "node_1")
//}
