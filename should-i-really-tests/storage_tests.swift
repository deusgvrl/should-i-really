//
//  storage_tests.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 27/07/26.
//

import Testing
@testable import should_i_really

@MainActor
struct storage_tests {
    
    private let storage = StorageController(saveKey: "storage_unit_test")
    
    @Test("Verifies save data exists")
    func test_save_data_exists() {
        storage.deleteGame()
        defer { storage.deleteGame() }
        
        #expect(storage.hasSave == false)
        
        let state = GameState(username: "testUser", ornamentsOrder: nil, lastEndingId: nil)
        storage.saveGame(state)
        
        #expect(storage.hasSave == true)
        
    }
    
    @Test("Verifies writing game state to storage")
    func test_write_save_data() {
        storage.deleteGame()
        defer { storage.deleteGame() }
        
        let testState = GameState(username: "testUser", ornamentsOrder: nil, lastEndingId: nil)
        storage.saveGame(testState)
        
        let loadedState: GameState? = storage.loadGame()
        
        #expect(loadedState?.username == "testUser")
        
    }
    
    @Test("Verifies overwrite save date")
    func test_overwrite_save_data() {
        storage.deleteGame()
        
        defer {storage.deleteGame()}
        
        let firstState = GameState(username: "PlayerOne", ornamentsOrder: nil, lastEndingId: nil)
        storage.saveGame(firstState)
        
        let updatedState = GameState(username: "PlayerTwo", ornamentsOrder: nil, lastEndingId: nil)
        storage.saveGame(updatedState)
        
        let loadedState = storage.loadGame()
        #expect(loadedState?.username == "PlayerTwo")
    }
}

