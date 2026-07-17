//
//  PostCreationViewModel.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI
import Observation

@Observable
final class PostCreationViewModel {
    // MARK: - Private Dependencies
    private var gameViewModel: GameViewModel
        
    // MARK: - UI State Properties (Child)
    var selectedQuadrant: QuadrantPosition? = nil {
        didSet {
            updateAvailableCaptions()
        }
    }
    
    var onPostFinished: (() -> Void)?
    
    var availableCaptions: [CaptionOption] = []
    var selectedCaption: CaptionOption? = nil
    
    var currentImageName: String {
        return gameViewModel.currentNode?.imageName ?? ""
    }
    
    var activeQuadrants: Set<QuadrantPosition> {
        return gameViewModel.currentNode?.activeQuadrants ?? []
    }
        
    // MARK: - Navigation Triggers
    var navigateToCaptionScreen: Bool = false
        
    // MARK: - Initializer
    init(gameViewModel: GameViewModel) {
        self.gameViewModel = gameViewModel
    }
        
    // MARK: - Internal Helper Logic
    private func updateAvailableCaptions() {
        if let quadrant = selectedQuadrant,
           let node = gameViewModel.currentNode {
            self.availableCaptions = node.options[quadrant] ?? []
        } else {
            self.availableCaptions = []
        }
    }
        
    // MARK: - View Actions
        
    // tombol "Next" di choose photo
    func confirmPhotoSelection() {
        guard selectedQuadrant != nil else { return }
        self.navigateToCaptionScreen = true
    }
        
    // choose 1 of 2 captions
    func selectCaption(_ caption: CaptionOption) {
        self.selectedCaption = caption
    }
        
    // tombol post di choose caption
    func finalizeAndPost() {
        guard let selected = selectedCaption, let quadrant = selectedQuadrant else { return }
            
        // Laporkan pilihan ke Induk (GameViewModel) untuk diproses
        // GameViewModel yang akan mengurus muat JSON baru atau masuk ke Ending
        gameViewModel.advanceStory(nextNodeId: selected.nextNodeId, chosenQuadrant: quadrant, chosenCaption: selected)
            
        // Reset state untuk ronde berikutnya
        self.selectedQuadrant = nil
        self.selectedCaption = nil
        self.availableCaptions = []
        self.navigateToCaptionScreen = false
        
        onPostFinished?()
    }
    
}
