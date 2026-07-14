//
//  StorageCOntroller.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import Foundation


// MARK: - Storage Controller
public final class StorageController {
    
    // MARK: - Save State Key
    private let saveKey = "shouldIReally.saveState"
    
    // MARK: - Initializer
    public init () {
        
    }
    // MARK: - Save State Check
    public var hasSave: Bool {
        UserDefaults.standard.object(forKey: saveKey) != nil
    }
    
    // MARK: - CRUD Operation
    public func saveGame (_ state: GameState) {
        do {
            let encoded = try JSONEncoder().encode(state)
            UserDefaults.standard.set(encoded, forKey: saveKey)
        } catch {
            // TODO: - Replace print statements with dedicated unified logging system (OSLog) in productiond
            print("Failed to save game state: \(error)")
        }
    }
    
    public func loadGame () -> GameState? {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return nil }
        do {
            let state = try JSONDecoder().decode(GameState.self, from: data)
            return state
        } catch {
            // TODO: Route errors to central debugging dashboard
            print("Failed to load game state: \(error)")
            return nil
        }
    }
    
    public func deleteGame () {
        UserDefaults.standard.removeObject(forKey: saveKey)
    }
}
