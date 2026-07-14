//
//  PostCreationViewModel.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI
import Combine

final class PostCreationViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var captionChoices: [Caption] = []
    @Published var selectedCaption: Caption?
    
    // MARK: - Placeholder Photo
    @Published var selectedPhotoName: String {
        
        didSet {
            // Caption ganti kalau foto nya udah ganti
            updateCaptionsForSelectedPhoto()
        }
    }
    
    // MARK: - Init
    init(initialPhoto: String = "placeholder_1") {
        self.selectedPhotoName = initialPhoto
        updateCaptionsForSelectedPhoto()
    }
    
    // MARK: - Dinamic Caption
    private func updateCaptionsForSelectedPhoto() {
            // Reset pilihan klo foto berubah
            self.selectedCaption = nil
            
            switch selectedPhotoName {
            case "placeholder_1":
                self.captionChoices = [
                    Caption(text: "caption jelek"),
                    Caption(text: "The original layout is way too crowded")
                ]
            case "placeholder_2":
                self.captionChoices = [
                    Caption(text: "bagus captionnya"),
                    Caption(text: "The layout is beautiful")
                ]
            default:
                self.captionChoices = [
                    Caption(text: "1"),
                    Caption(text: "2")
                ]
            }
        }
    
    func selectCaption(_ caption: Caption) {
        selectedCaption = caption
    }
    
    // MARK: - Boolean
    var isCaptionSelected: Bool {
        selectedCaption != nil
    }
    
    func isCurrentSelection(_ caption: Caption) -> Bool {
        selectedCaption?.id == caption.id
    }
    
    // MARK: - Placeholder Action
    func proceedToNextStep() {
        guard isCaptionSelected else { return }
        // TODO: [CA7-11] lanjut share post
        print("Caption: \(selectedCaption?.text ?? "")")
    }
}
