//
//  ProfilePageView.swift
//  should-i-really
//
//  Created by Jose Putra Perdana Taneo on 14/07/26.
//

import SwiftUI

struct ProfilePageView: View {
    private var data = Array(1...7)
    private let gridColumns = Array(
        repeating: GridItem(.flexible(), spacing: 1),
        count: 3
    )
    
    var body: some View {
        ZStack {
            VStack() {
                // MARK: Top Bar (Username + Home Button)
                ZStack {
                    HStack {
                        Image(systemName: "house")
                            .resizable()
                            .frame(width: 28, height: 28)
                        Spacer()
                    }
                    HStack() {
                        Spacer()
                        Text("johndoe")
                            .fontWeight(.bold)
                            .font(.headline)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                //            .border(.blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
                // MARK: Profile Picture + Timeline
                HStack {
                    Image("pp")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    Spacer()
                    Text("Year 1 Semester 1 Month 1")
                        .font(.callout)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                //            .border(.blue)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                //MARK: Bio
                Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                )
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                //            .border(.brown)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                
                //MARK: Grid Icon
                Image(systemName: "square.grid.3x3.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                
                
                //MARK: Posts Feed Preview
                ScrollView {
                    LazyVGrid(columns: gridColumns, spacing: 1) {
                        ForEach(data, id: \.self) { item in
                            Button {
                                
                            } label: {
                                Image("pp")
                                    .resizable()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity,)
                                    .aspectRatio(1, contentMode: .fill)
                                    .background(.blue)
                            }
                        }
                    }
                    //                .border(.black)
                }
                
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            //MARK: Add Post Button
            VStack {
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.borderedProminent)
                .clipShape(.circle)
            }
        }
//        .border(.black)
    }
}

#Preview {
    ProfilePageView()
}

