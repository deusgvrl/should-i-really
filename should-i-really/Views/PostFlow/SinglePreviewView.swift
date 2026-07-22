//
//  SinglePreviewView.swift
//  should-i-really
//
//  Created by Jose Putra Perdana Taneo on 22/07/26.
//

import SwiftUI

struct SinglePreviewView: View {
    let node: UserPost
    let size: CGSize
    var ornament: String? = nil
    
    private var imageSize: CGFloat {
        return size.width - 16
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.textBrown, lineWidth: 1)
            
            VStack(spacing: 0) {
                Group {
                    if node.nodeId == "first_post" || node.nodeId == "last_post" {
                        Image(node.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageSize, height: imageSize)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 12,
                                    style: .circular
                                )
                            )
                            .clipped()
                    } else {
                        QuadrantImageView(
                            imageName: node.imageName,
                            quadrant: node.selectedQuadrant,
                            size: imageSize
                        )
                    }
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.textBrown, lineWidth: 1)
                )
                .padding(.top, 12)
                Spacer()
            }
            
            if let ornamentName = ornament {
                switch ornamentName {
                case "icon_star":
                    Image(ornamentName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .offset(x: -size.width/2 + 32, y: size.height/2 - 36)
                case "icon_pin":
                    Image(ornamentName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 60)
                        .rotationEffect(.degrees(0))
                        .offset(x: -size.width/2 + 28, y: -size.height/2 + 23)
                case "icon_pushPin":
                    Image(ornamentName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .offset(x: 0, y: -size.height/2 + 8)
                
                default:
                    EmptyView()
                }
            }
        }
    }
}

#Preview("Polaroid Tweaker") {
    let dummyNode = UserPost(nodeId: "2A", imageName: "SampleImage5", selectedQuadrant: .topLeft,
                             selectedCaptionText: "", comment: nil, photoGuardResult: .positive, vibeCheckResult: .positive)
        
    return GeometryReader { geo in
        SinglePreviewView(node: dummyNode, size: geo.size, ornament: "icon_star")
    }
    .frame(width: 160)
    .aspectRatio(0.82, contentMode: .fit) 
    .padding(40)
}
