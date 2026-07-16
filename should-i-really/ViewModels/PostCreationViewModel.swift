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
    // MARK: -- PUNYA JOSE
    // MARK: - State Properties
        var currentRound: Int = 1
        var currentNodeId: String = ""
        var selectedBigPicture: String = ""
        
        var positiveCropQuadrant: QuadrantPosition = .topLeft
        var negativeCropQuadrant: QuadrantPosition = .bottomLeft
        
        var isPositiveCropSelected: Bool = true
        var captionChoices: [CaptionOption] = []
        var selectedCaption: CaptionOption?
        
        // MARK: - Navigation Triggers
        var navigateToCaptionScreen: Bool = false
        var gameFinished: Bool = false
        var finalEndingId: String = ""
        
        // MARK: - Local Database
        // simpan data skenario untuk ronde sekarang
        private var currentRoundDatabase: [String: ScenarioNode] = [:]
        
        // MARK: - Inisialisasi Awal
        init() {
            // Saat ViewModel pertama kali dibuat, langsung muat data Ronde 1
            startGame()
        }
        
        func startGame() {
            self.gameFinished = false
            self.finalEndingId = ""
            self.currentNodeId = "1A"
            
            loadJSONDatabase(forRound: 1)
            loadNode(id: currentNodeId)
        }
        
        // MARK: - Loading JSON
        private func loadJSONDatabase(forRound round: Int) {
            let fileName = "Round\(round)_Nodes"
            
            // cari file JSON
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                print("ERROR: File \(fileName).json tidak ditemukan!")
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let nodes = try JSONDecoder().decode([ScenarioNode].self, from: data)
                // Dictionary
                self.currentRoundDatabase = Dictionary(uniqueKeysWithValues: nodes.map { ($0.id, $0) })
                print("Berhasil load \(nodes.count) skenario untuk ronde \(round)")
            } catch {
                print("Gagal decode JSON Ronde \(round): \(error)")
            }
        }
        
        private func loadNode(id: String) {
            guard let node = currentRoundDatabase[id] else {
                print("ERROR: Node \(id) tidak ditemukan di database Ronde \(currentRound).")
                return
            }
            
            self.currentRound = node.round
            self.selectedBigPicture = node.bigPictureId
            self.positiveCropQuadrant = node.crops.positiveCrop.quadrant
            self.negativeCropQuadrant = node.crops.negativeCrop.quadrant
            
            // Reset waktu load node/ronde baru
            self.selectedCaption = nil
            self.navigateToCaptionScreen = false
        }
        
        // MARK: - Player Actions
        func selectCrop(isPositive: Bool) {
            self.isPositiveCropSelected = isPositive
            
            // load caption sesuai selected photo
            if let node = currentRoundDatabase[currentNodeId] {
                self.captionChoices = isPositive ? node.crops.positiveCrop.captions : node.crops.negativeCrop.captions
            }
            
            // Pindah ke Layar 2
            self.navigateToCaptionScreen = true
        }
        
        func selectCaption(_ caption: CaptionOption) {
            self.selectedCaption = caption
        }
        
        func proceedToNextRound() {
            guard let selected = selectedCaption else { return }
            let nextDestination = selected.nextNodeId
            
            // Cek apakah tujuan berikutnya adalah Ending
            if nextDestination.hasPrefix("ENDING_") {
                self.finalEndingId = nextDestination
                self.gameFinished = true
            } else {
                // Naikkan angka ronde saat ini
                let nextRound = self.currentRound + 1
                
                // Muat file JSON yang baru sebelum memuat node-nya
                loadJSONDatabase(forRound: nextRound)
                
                // Lakukan transisi dengan animasi
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.currentNodeId = nextDestination
                    self.loadNode(id: nextDestination)
                }
            }
        }
    
    
    // MARK: -- PUNYA FANY & MICH
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
