//
//  ArchiveView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 16/07/26.
//

import SwiftUI
import SwiftData

struct ArchiveView: View {
    @Query var unlockedEndings: [UnlockedEndings]
    @State private var endingVM = EndingViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            // MARK: - Background Layer
            Color.background
                .ignoresSafeArea()
            
            ScrollView {
                // MARK: - Header
                VStack(spacing: 4) {
                    Text("Collect All Endings!")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.textBrown)
                }
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
                
                // MARK: - Grid
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(1...16, id: \.self) { index in
                        let endingKey = "ENDING_\(index)"
                        let isUnlocked = unlockedEndings.contains { $0.endingId == endingKey }
                        let endingDetail = endingVM.getEnding(by: endingKey)
                        
                        EndingCardView(
                            index: index,
                            isUnlocked: isUnlocked,
                            ending: endingDetail
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Endings (\(unlockedEndings.count)/16)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textBrown)
            }
        }
    }
}

#Preview {
    ArchiveView()
}
