//
//  EndingViewModel.swift
//  should-i-really
//
//  Created by Michael David Sin on 20/07/26.
//

import Foundation
import Observation

@Observable
public final class EndingViewModel {
    // MARK: - Published States
    public private(set) var currentEnding: EndingNode?
    private var endingsDatabase: [String: EndingNode] = [:]
    
    // MARK: - Initializer
    public init(endingId: String? = nil) {
        loadEndingsFromJSON()
        if let endingId = endingId {
            selectEnding(id: endingId)
        }
    }
    
    // MARK: - Data Loader
    private func loadEndingsFromJSON() {
        guard let url = Bundle.main.url(forResource: "Endings", withExtension: "json") else {
            print("ERROR: File Endings.json tidak ditemukan di Bundle!")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let endings = try decoder.decode([EndingNode].self, from: data)
            
            // Map array ke dictionary pake key 'id'
            self.endingsDatabase = Dictionary(uniqueKeysWithValues: endings.map { ($0.id, $0) })
            print("Berhasil memuat Endings.json (\(endings.count) ending terdaftar)")
        } catch {
            print("Gagal decode Endings.json: \(error)")
        }
    }
    
    // MARK: - Action Methods
    public func selectEnding(id: String) {
        if let ending = endingsDatabase[id] {
            self.currentEnding = ending
        } else {
            print("WARNING: Ending dengan ID '\(id)' tidak ditemukan di database JSON.")
        }
    }
    
    public func getEnding(by id: String) -> EndingNode? {
        return endingsDatabase[id]
    }
}
