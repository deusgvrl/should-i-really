//
//  ProfilePageView.swift
//  should-i-really
//
//  Created by Jose Putra Perdana Taneo on 14/07/26.
//

import SwiftUI

struct ProfilePageView: View {
    var imageBank: [String] = ["7", "6", "5", "4", "3", "2", "1"]
    private let gridColumns = Array(
        repeating: GridItem(.flexible(), spacing: 1),
        count: 3
    )
    
    var body: some View {
        NavigationStack {
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
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    
                    // MARK: Profile Picture + Timeline
                    ScrollView {
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
                        LazyVGrid(columns: gridColumns, spacing: 1) {
                            ForEach(imageBank, id: \.self) { item in
                                NavigationLink(value: item) {
                                    Image(item)
                                        .resizable()
                                        .frame(
                                            maxWidth: .infinity,
                                            maxHeight: .infinity,
                                        )
                                        .aspectRatio(1, contentMode: .fill)
                                        .clipped()
                                }
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
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
            .navigationDestination(for: String.self) { selectedPostID in
                ProfileFeedView(posts: imageBank, initialPostID: selectedPostID)
            }
        }
        //        .border(.black)
    }
}

#Preview {
    ProfilePageView()
}

