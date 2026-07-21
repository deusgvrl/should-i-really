//
//  archive_tests.swift
//  should-i-really
//
//  Created by Michael David Sin on 21/07/26.
//

import Testing
import SwiftData
import Foundation
@testable import should_i_really

@Suite("Archive & Endings Unit Tests")
@MainActor
struct ArchiveTests {
    
    // Helper In-Memory SwiftData Container
    private func makeModelContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: UnlockedEndings.self, configurations: config)
    }

    // MARK: - Test 1: EndingViewModel Tests
    
    @Test("Ensure JSON database is loaded successfully on initialization")
    func loadsJSONDatabaseSuccessfully() {
        let endingVM = EndingViewModel()
        
        #expect(endingVM.getEnding(by: "ENDING_1") != nil)
        #expect(endingVM.getEnding(by: "ENDING_16") != nil)
    }
    
    @Test("getEnding returns the correct title and imageName for ENDING_13")
    func getEndingReturnsCorrectData() {
        let endingVM = EndingViewModel()
        let ending13 = endingVM.getEnding(by: "ENDING_13")
        
        #expect(ending13 != nil)
        #expect(ending13?.title == "The Validation Seeker")
        #expect(ending13?.imageName == "SampleImage3")
    }
    
    @Test("getEnding with invalid ID returns nil")
    func getEndingWithInvalidIDReturnsNil() {
        let endingVM = EndingViewModel()
        let invalidEnding = endingVM.getEnding(by: "INVALID_KEY")
        
        #expect(invalidEnding == nil)
    }

    // MARK: - Test 2: SwiftData Archive Logic Tests
    
    @Test("New user initial load returns empty unlocked endings list")
    @MainActor
    func initialLoadForNewUserReturnsEmpty() throws {
        let container = try makeModelContainer()
        let context = container.mainContext
        
        let descriptor = FetchDescriptor<UnlockedEndings>()
        let existingData = try context.fetch(descriptor)
        
        #expect(existingData.isEmpty)
    }
    
    @Test("Successfully insert and save a new unlocked ending to SwiftData")
    @MainActor
    func unlockEndingSavesToSwiftData() throws {
        let container = try makeModelContainer()
        let context = container.mainContext
        
        let endingId = "ENDING_13"
        let newUnlocked = UnlockedEndings(endingId: endingId, unlockedAt: Date())
        
        context.insert(newUnlocked)
        try context.save()
        
        let descriptor = FetchDescriptor<UnlockedEndings>()
        let fetched = try context.fetch(descriptor)
        
        #expect(fetched.count == 1)
        #expect(fetched.first?.endingId == endingId)
    }
    
    @Test("Existing user data loads all previously saved unlocked endings")
    @MainActor
    func loadExistingUserDataReturnsAllSavedEndings() throws {
        let container = try makeModelContainer()
        let context = container.mainContext
        
        let savedEndings = ["ENDING_1", "ENDING_5", "ENDING_13"]
        for id in savedEndings {
            context.insert(UnlockedEndings(endingId: id, unlockedAt: Date()))
        }
        try context.save()
        
        let descriptor = FetchDescriptor<UnlockedEndings>()
        let loadedEndings = try context.fetch(descriptor)
        
        #expect(loadedEndings.count == 3)
        let loadedIDs = loadedEndings.map { $0.endingId }
        #expect(loadedIDs.contains("ENDING_1"))
        #expect(loadedIDs.contains("ENDING_5"))
        #expect(loadedIDs.contains("ENDING_13"))
    }
    
    @Test("Archive matching logic correctly identifies unlocked and locked status")
    @MainActor
    func archiveMatchingLogicIdentifiesCorrectStatus() throws {
        let container = try makeModelContainer()
        let context = container.mainContext
        
        let unlockedId = "ENDING_5"
        context.insert(UnlockedEndings(endingId: unlockedId, unlockedAt: Date()))
        try context.save()
        
        let descriptor = FetchDescriptor<UnlockedEndings>()
        let unlockedEndings = try context.fetch(descriptor)
        
        let isEnding5Unlocked = unlockedEndings.contains { $0.endingId == "ENDING_5" }
        let isEnding6Unlocked = unlockedEndings.contains { $0.endingId == "ENDING_6" }
        
        #expect(isEnding5Unlocked)
        #expect(!isEnding6Unlocked)
    }
}
