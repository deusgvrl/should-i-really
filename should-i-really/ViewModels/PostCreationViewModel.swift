//
//  PostCreationViewModel.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI
import Observation

@Observable
class PostCreationViewModel {
    // MARK: - Core Properties (No @Published wrappers needed!)
    var currentImageName: String
    var activeQuadrants: Set<Quadrant>
    
    var availableCaptions: [String] = []
    
    var selectedQuadrant: Quadrant? = nil {
        didSet {
            updateAvailableCaptions()
        }
    }
    
    var selectedCaptionIndex: Int? = nil
    
    var navigateToCaptionPage: Bool = false
    
    // MARK: - Private Dependencies
    private var gameViewModel: GameViewModel
    
    // MARK: - Initializer
    init(gameViewModel: GameViewModel) {
        self.gameViewModel = gameViewModel
        
        let node = gameViewModel.currentNode
        self.currentImageName = node.imageName
        self.activeQuadrants = node.activeQuadrants
        
        updateAvailableCaptions()
    }
    
    // MARK: - Internal Helper Logic
    private func updateAvailableCaptions() {
        if let quadrant = selectedQuadrant {
            self.availableCaptions = gameViewModel.currentNode.quadrantCaptions[quadrant] ?? []
        } else {
            self.availableCaptions = []
        }
    }
    
    // MARK: - View Actions
    
    func confirmPhotoSelection() {
        guard selectedQuadrant != nil else { return }
        navigateToCaptionPage = true
    }
    
    func finalizeAndPost() {
        guard let quadrant = selectedQuadrant,
              let captionIndex = selectedCaptionIndex else { return }
        
        gameViewModel.advanceStory(chosenQuadrant: quadrant, chosenCaptionIndex: captionIndex)
        
        let nextNode = gameViewModel.currentNode
        self.currentImageName = nextNode.imageName
        self.activeQuadrants = nextNode.activeQuadrants
        
        self.selectedQuadrant = nil
        self.selectedCaptionIndex = nil
        self.availableCaptions = []
    }
}
