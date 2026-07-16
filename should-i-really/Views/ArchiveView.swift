//
//  ArchiveView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 16/07/26.
//

import SwiftUI
import SwiftData

struct ArchiveView: View {
    let viewModel = GameViewModel()
    // Queries the unlocked ending that will return the id and the date
    @Query var unlockedEndings: [UnlockedEndings]
    // TODO: - Need to specify the brown colour globally.
    let themeBrown = Color(red: 0.65, green: 0.49, blue: 0.32)
    // Uses 2 columns
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        ScrollView {
            VStack(spacing :4) {
                Text("\(unlockedEndings.count) of 16 unlocked")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(themeBrown)
                
                Text("Complete scenarios to unlock your graduation endings")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(1...16, id: \.self) { index in
                    let endingKey = "Ending \(index)"
                    let isUnlocked = unlockedEndings.contains { $0.endingId == endingKey }
                    
                    EndingCardView(index: index, isUnlocked: isUnlocked)
                }
            }
            .padding(24)
        }
        .navigationTitle("Graduation Archive")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ArchiveView()
}
